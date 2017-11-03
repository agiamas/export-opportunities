class Admin::SessionsController < Devise::SessionsController
  def after_sign_in_path_for(resource)
    loc = stored_location_for(resource)
    pp "location to redirect:"
    pp loc
    pp admin_opportunities_path
    # return loc if loc
    return loc if loc.include?('/admin/help') || loc.include?('/admin/enquiries')
    admin_opportunities_path
    end


  def after_sign_out_path_for(_resource)
    new_editor_session_path
  end

  def new
    self.resource = resource_class.new(sign_in_params)
    store_location_for(resource, params[:redirect_to])
    super
  end
end
