class Devise::RevocationsController < ApplicationController
  include Devise::Controllers::InternalHelpers

  # GET /resource/revocation/confirm?revocation_token=abcdef
  def edit
    if params[:revocation_token] && self.resource = resource_class.find_by_revocation_token(params[:revocation_token])
      render_with_scope :edit
    else
      set_error_and_redirect
    end
  end

  # PUT /resource/revocation
  def update
    token = params[resource_name].try(:[], :revocation_token)

    self.resource = resource_class.revoke_by_token(token)

    if resource.errors.empty?
      set_flash_message :notice, :updated
      sign_out(self.resource)
      render_with_scope :edit
    else
      set_error_and_redirect
    end
  end

  protected

    def set_error_and_redirect
      set_flash_message(:alert, :revocation_token_invalid)
      redirect_to after_sign_out_path_for(resource_name)
    end
end
