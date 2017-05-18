class OpportunityPolicy < ApplicationPolicy
  def always_allow
    true
  end

  alias index? always_allow
  alias new? always_allow
  alias create? always_allow

  def show?
    @record.publish? || editor_is_admin_or_publisher_or_reviewer? || editor_is_record_owner? || editor_has_same_service_provider?
  end

  def show_enquiries?
    publishing? || @editor.role == 'reviewer' || editor_has_same_service_provider? || editor_is_record_owner?
  end

  def edit?
    return true if editor_is_record_owner? && (@record.pending? || @record.trash? || @record.draft?)
    editor_is_admin_or_publisher?
  end

  def update?
    edit?
  end

  def uploader_reviewer?
    @editor.role == 'uploader' || @editor.role == 'reviewer'
  end

  def administrator?
    @editor.role == 'administrator'
  end

  def publishing?
    editor_is_admin_or_publisher?
  end

  def drafting?
    draft?
  end

  def trash?
    (administrator? && (@record.pending? || @record.draft?)) || ((@editor.role == 'uploader' || @editor.role == 'reviewer') && @record.status == 'draft' && editor_is_record_owner?)
  end

  def restore?
    administrator? && @record.trash?
  end

  def uploader_reviewer_restore?
    (uploader_reviewer? && @record.status == 'draft' && editor_is_record_owner?) || administrator?
  end

  def draft?
    (uploader_reviewer? && @record.status == 'trash' && editor_is_record_owner?) || administrator?
  end

  private

  def editor_is_record_owner?
    @editor == @record.author
  end

  def editor_has_same_service_provider?
    return false unless @editor.service_provider.present?
    @record.service_provider == @editor.service_provider
  end

  class Scope
    attr_reader :editor, :scope

    def initialize(editor, scope)
      @editor = editor
      @scope = scope
    end

    def resolve
      return scope.all if %w(administrator publisher reviewer).include? editor.role
      scope.published
        .union(scope.where(author: @editor))
        .union(scope.where.not(service_provider: nil).where(service_provider: @editor.service_provider))
    end
  end
end
