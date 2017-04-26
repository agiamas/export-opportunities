require 'logger'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :developer

  # This method name matches the omniauth provider name
  # https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
  def exporting_is_great
    logger = Logger.new(STDOUT)
    logger.error('omniauth.auth:')
    logger.error(request.env['omniauth.auth'])
    @user = User.from_omniauth(request.env['omniauth.auth'])
    sign_in_and_redirect @user
    set_flash_message(:notice, :success) if is_navigational_format?
  end

  def developer
    @user = User.from_omniauth(request.env['omniauth.auth'])
    sign_in_and_redirect @user
    set_flash_message(:notice, :success) if is_navigational_format?
  end

  def failure
    @error = env['omniauth.error.type']
  end
end
