class Admin::OpportunityStatusController < Admin::BaseController
  before_action :set_paper_trail_whodunnit

  def update
    opportunity = Opportunity.find(params[:opportunity_id])
    authorize(opportunity, :publishing?)

    new_status = params[:status]
    result = UpdateOpportunityStatus.new.call(opportunity, new_status)

    if result.success?
      redirect_to admin_opportunity_path(opportunity), notice: %(This opportunity #{result.message})
    else
      redirect_to admin_opportunity_path(opportunity), alert: %(This opportunity has a problem. Please edit and save to resolve any issues.)
    end
  end

  def destroy
    opportunity = Opportunity.find(params[:opportunity_id])
    authorize(opportunity, :trash?)

    opportunity.status = :trash
    opportunity.ragg = :undefined
    opportunity.save!(validate: false)

    redirect_to admin_opportunity_path(opportunity), notice: %(This opportunity was moved to Trash)
  end
end
