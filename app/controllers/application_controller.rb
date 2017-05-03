class ApplicationController < ActionController::Base
  # Protect by basic auth on staging
  # Use basic auth if set in the environment
  before_action :basic_auth, except: :check

  rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_authenticity_token

  def basic_auth
    return unless Figaro.env.staging_http_user? && Figaro.env.staging_http_pass?
    authenticate_or_request_with_http_basic do |name, password|
      name == Figaro.env.staging_http_user && password == Figaro.env.staging_http_pass
    end
  end

  before_action :set_google_tag_manager

  def set_google_tag_manager
    if Figaro.env.google_tag_manager_keys?
      @google_tag_manager = Figaro.env.google_tag_manager_keys.split(',').map(&:strip)
    else
      @google_tag_manager = []
    end
  end

  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::UnknownFormat, with: :unsupported_format
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :administrator?
  helper_method :staff?

  layout :determine_layout

  def check
    render json: { status: 'OK' }, status: 200
  end

  # basic checks for data sync between ES and PG DB
  def data_sync_check
    res = []
    db_opportunities_ids = []
    es_opportunities_ids = []

    # opps that have not expired and are published
    db_opportunities = Opportunity.where("response_due_on >= ? and status = ?", DateTime.now, 2)
    db_opportunities_ids = db_opportunities.pluck(:id)
    sort = OpenStruct.new(column: :response_due_on, order: :desc)
    query = OpportunitySearchBuilder.new(search_term: '', sort: sort).call
    es_opportunities = Opportunity.__elasticsearch__.search(size: 10000, query: query[:search_query], sort: query[:search_sort])
    es_opportunities.each { |record| es_opportunities_ids.push record.id }

    res_opportunities_count = db_opportunities_ids.size == es_opportunities_ids.size
    res << { expected_opportunities: db_opportunities_ids.size, actual_opportunities: es_opportunities_ids.size }
    if db_opportunities_ids.size != es_opportunities_ids.size
      missing_docs = db_opportunities_ids - es_opportunities_ids
      Rails.logger.error("we are missing docs")
      Rails.logger.error(missing_docs)
    end

    db_subscriptions_count = Subscription.count
    es_subscriptions_count = Subscription.__elasticsearch__.count
    res_subscriptions_count = db_subscriptions_count == es_subscriptions_count

    res << { expected_subs: db_subscriptions_count, actual_subs: es_subscriptions_count }

    result = res_opportunities_count || res_subscriptions_count
    case result
    when true
      render json: { status: 'OK', result: res }, status: 200
    else
      render json: { status: 'error', result: res }, status: 500
    end
  end

  def determine_layout
    return 'admin' if request.path.start_with?('/admin') && staff?
    'application'
  end

  def require_sso!
    return if current_user

    # So omniauth can return us where we left off
    store_location_for(:user, request.url)

    if Figaro.env.bypass_sso?
      redirect_to user_omniauth_authorize_path(:developer)
    else
      redirect_to user_omniauth_authorize_path(:exporting_is_great)
    end
  end

  private

  def administrator?
    current_editor&.administrator?
  end

  def staff?
    current_editor&.staff?
  end

  def check_if_admin
    not_found unless administrator?
  end

  def not_found
    respond_to do |format|
      format.html { render 'errors/not_found', status: 404 }
      format.json { render json: { errors: 'Resource not found' }, status: 404 }
      format.all { render status: 404, nothing: true }
    end
  end

  def unsupported_format
    respond_to do |format|
      format.json { render json: { errors: 'JSON is not supported for this resource' }, status: 406 }
      format.all { render status: 406, nothing: true }
    end
  end

  def user_not_authorized
    render 'errors/unauthorized', status: 401
  end

  def internal_server_error
    render 'errors/internal_server_error', status: 500
  end

  def invalid_authenticity_token(exception)
    Raven.capture_exception(exception)
    set_google_tag_manager
    # ^ this method call is necessary to render
    #   the layout. It is usually run in a before_action.
    # The exception this method rescues from is thrown
    # before it has the chance.
    render 'errors/invalid_authenticity_token', status: 422
  end
end
