class EnquiryForm
  attr_reader :from, :to, :order_by, :order_column

  def initialize(params)
    @order_column = :created_at
    @order_by = :desc
    @from = parse_date params.fetch(:created_at_from, {})
    @to = parse_date params.fetch(:created_at_to, {})
  end

  def dates?
    from.present? && to.present?
  end

  private def parse_date(params)
    return nil if params.nil?
    return nil unless params[:year].present?
    return nil unless params[:month].present?
    return nil unless params[:day].present?
    Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
  end
end
