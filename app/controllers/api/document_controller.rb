require 'digest'

module Api
  class DocumentController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      params[:id].to_i
    end

    def create
      @error = {
        errors: {
          type: 'virus found',
          message: 'file is not clean',
        },
      }
      doc_params = params['enquiry_response']
      unless doc_params
        Raven.capture_exception('no doc_params found. cant process document creation in enquiry response')
        raise Exception, 'no doc params found'
      end

      enquiry_id = doc_params['enquiry_id']
      user_id = doc_params['user_id']
      original_filename = doc_params['original_filename']
      validation_result = DocumentValidation.new.call(doc_params, doc_params['file_blob'])
      return validation_result if validation_result[:errors]
      res = DocumentStorage.new.call(original_filename, doc_params['file_blob'].path)
      if res
        s3_filename = enquiry_id.to_s + '_' + user_id.to_s + '_' + original_filename
        document_url = 'https://s3.' + Figaro.env.aws_region_ptu! + '.amazonaws.com/' + Figaro.env.post_user_communication_s3_bucket! + '/' + s3_filename
        short_url = DocumentUrlShortener.new.shorten_and_save_link(document_url, user_id, enquiry_id, original_filename)
      else
        Raven.capture_exception('couldnt store file to S3:')
        Raven.capture_exception(doc_params)
        return {
          errors: {
            type: 'error saving',
            message: 'couldnt store file to S3',
          },
        }
      end
      @result = {
        status: 200,
        id: short_url,
        base_url: Figaro.env.domain! + '/dashboard/downloads/',
      }
      respond_to do |format|
        format.json { render json: { result: @error }, status: 200 }
        format.js { render json: { result: @error }, status: 200 }
        format.html { render json: { result: @error }, status: 200 }
      end
    end
  end
end
