class Devise::ParanoidVerificationCodeController < DeviseController
<<<<<<< HEAD
<<<<<<< HEAD
  skip_before_action :handle_paranoid_verification
=======
  skip_before_action :handle_paranoid_verification, raise: false
>>>>>>> 30f043d9... (feature) updated rails to 5.1, ruby to 2.4.3
=======
  skip_before_action :handle_paranoid_verification
>>>>>>> 561d1a71... (fix) rails 5.1.4 to resolve SELECT DISTINCT, ORDER BY issue, fixed most tests
  prepend_before_action :authenticate_scope!, :only => [:show, :update]

  def show
    if !resource.nil? && resource.need_paranoid_verification?
      respond_with(resource)
    else
      redirect_to :root
    end
  end

  def update
    if resource.verify_code(resource_params[:paranoid_verification_code])
      warden.session(scope)['paranoid_verify'] = false
      set_flash_message :notice, :updated
      bypass_sign_in resource, scope: scope
      redirect_to stored_location_for(scope) || :root
    else
      respond_with(resource, action: :show)
    end
  end

  private

  def resource_params
    if params.respond_to?(:permit)
      params.require(resource_name).permit(:paranoid_verification_code)
    else
      params[scope].slice(:paranoid_verification_code)
    end
  end

  def scope
    resource_name.to_sym
  end

  def authenticate_scope!
    send(:"authenticate_#{resource_name}!")
    self.resource = send("current_#{resource_name}")
  end
end
