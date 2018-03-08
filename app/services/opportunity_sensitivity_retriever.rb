require 'opps_sensitivity_connector'

class OpportunitySensitivityRetriever
  def call(opportunity)
    hostname = Figaro.env.AZ_HOSTNAME!
    sensitivity_api_key = Figaro.env.AZ_API_KEY!
    submitted_text = "#{opportunity.title} #{opportunity.description}"

    response = OppsSensitivityConnector.new.call(submitted_text, hostname, sensitivity_api_key)
    hashed_response = JSON.parse(response)

    valid_response = validate_response(hashed_response)

    if valid_response
      opp_sensitivity_check = OpportunitySensitivityCheck.new

      opp_sensitivity_check.error_id = hashed_response['TrackingId']
      opp_sensitivity_check.submitted_text = hashed_response['OriginalText']

      classification = hashed_response['Classification']
      opp_sensitivity_check.review_recommended = classification['ReviewRecommended']
      opp_sensitivity_check.category1_score = classification['Category1']['Score']
      opp_sensitivity_check.category2_score = classification['Category2']['Score']
      opp_sensitivity_check.category3_score = classification['Category3']['Score']

      opp_sensitivity_check.language = hashed_response['Language']

      opp_sensitivity_check.opportunity_id = opportunity.id

      opp_sensitivity_check.save!

      hashed_response['Terms']&.each do |term|
        check_term = OpportunitySensitivityTermCheck.new
        check_term.index = term['Index']
        check_term.original_index = term['OriginalIndex']
        check_term.list_id = term['ListId']
        check_term.term = term['Term']

        check_term.opportunity_sensitivity_check_id = opp_sensitivity_check.id

        check_term.save!
      end

      { review_recommended: opp_sensitivity_check.review_recommended, category1_score: opp_sensitivity_check.category1_score, category2_score: opp_sensitivity_check.category2_score, category3_score: opp_sensitivity_check.category3_score }
    else
      Rails.logger.error "unknown error from API call #{hashed_response}"
    end
  end

  private def validate_response(hashed_response)
    if hashed_response['Message'].eql? 'Error'
      Rails.logger.error hashed_response['Errors']
      return false
    end

    # if we are rate limited by the API, we will discard the current sensitivity check in this run and go to the next one
    if hashed_response['statusCode'].eql? 429
      sleep 1
      return false
    end
    return false unless hashed_response['Status']['Description'].eql? 'OK'

    true
  end
end
