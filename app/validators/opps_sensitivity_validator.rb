class OppsSensitivityValidator
  def validate_each(opportunity)
    call(opportunity)
  end

  def call(opportunity)
    OpportunitySensitivityRetriever.new.call(opportunity)
  end
end
