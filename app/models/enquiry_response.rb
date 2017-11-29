class EnquiryResponse < ActiveRecord::Base
  mount_uploaders :attachments, EnquiryResponseUploader
  attr_accessor :completed_at
  # default_scope { where.not(completed_at: nil) }

  validate :email_body_length_check

  belongs_to :enquiry
  belongs_to :editor

  def email_body_length_check
    if email_body.empty? && response_type <= 3
      errors.add(:email_body, 'Please add a comment.')
    end
  end

  def response_type_to_human
    case response_type
    when 1
      'Won'
    when 2
      'Need more information'
    when 3
      'Did not win'
    when 4
      'Not UK registered'
    when 5
      'Not for third party'
    end
  end

  def documents_list
    return 'Not available' unless response_type == 1
    return 'none' if documents.blank?
    file_list = ''
    begin
      docs = JSON.parse(documents)
      docs.each do |document|
        file_list << document['result']['id']['original_filename'] + ' '
      end
      return file_list
    rescue JSON::ParserError
      return 'not available'
    end
  end
end
