class EnquiryResponse < ActiveRecord::Base
  mount_uploaders :attachments, EnquiryResponseUploader

  # TODO: add validations
  # validates_attachment_file_name :attachment, matches: [/ppt\Z/, /pptx\Z/, /pdf\Z/, /doc\Z/, /docx\Z/, /xls\Z/, /xlsx\Z/, /txt\Z/]
  # validates_attachment_size :attachment, in: 10.bytes..25.megabytes
  before_save :email_body_length_check
  # TODO: scan for viruses
  # before_save :scan_attachment

  belongs_to :enquiry
  belongs_to :editor

  def email_body_length_check
    if email_body.length < 30 and response_type <= 3
      errors.add(:email_body, 'You need at least 30 characters in your reply')
    end
  end

  def scan_attachment
    attachment = attachments.queued_for_write[:original]
    if attachment
      ApplicationController.helpers.scan_clean?(attachments.path)
    else
      errors.add(:virus_scanner, 'Your attachment is INFECTED. Please contact Export Opportunities helpdesk immediately') unless is_file_clean_or_no_file
    end
  end
end
