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

    if resource.confirmed?
      return sign_in_and_redirect(resource_name, resource)
    end

    super if !resource
  end

  def confirm
    @confirmation_token = params[resource_name][:confirmation_token]

    self.resource = find_resource_by_confirmation_token

    return render :show unless attributes_update_and_password_matches?

    confirm_resource

    if user_invited?
      sign_in_and_redirect_to_group_path
    else
      sign_in_and_redirect(resource_name, resource)
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

    def attributes_update_and_password_matches?
      resource_update_attributes? && resource.password_match?
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
      set_flash_message :notice, :confirmed unless user_invited?
    end

    def user_invited?
      params[:user][:invited] == "true"
    end

    def sign_in_and_redirect_to_group_path
      scope = Devise::Mapping.find_scope!(resource_name)
      sign_in(scope, resource)
      redirect_to group_path(group, invited: true)
    end

    def group
      @_group ||= Group.find(params[:user][:group_id].to_i)
    end
end
