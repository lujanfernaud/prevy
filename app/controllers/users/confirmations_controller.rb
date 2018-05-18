# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    @confirmation_token = params[:confirmation_token]

    self.resource = find_resource_by_confirmation_token

    super if resource_is_not_confirmable?
  end

  def confirm
    @confirmation_token = params[resource_name][:confirmation_token]

    self.resource = find_resource_by_confirmation_token

    if resource_update_attributes? && resource.password_match?
      confirm_resource
      sign_in_and_redirect(resource_name, resource)
    else
      render :show
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end

  private

    def find_resource_by_confirmation_token
      resource_class.find_by_confirmation_token(@confirmation_token)
    end

    def resource_is_not_confirmable?
      resource.nil? || resource.confirmed?
    end

    def resource_update_attributes?
      resource.update_attributes(
        params[resource_name].
        except(:confirmation_token).
        permit(:password, :password_confirmation)
      )
    end

    def confirm_resource
      self.resource = resource_class.confirm_by_token(@confirmation_token)
      set_flash_message :notice, :confirmed
    end
end
