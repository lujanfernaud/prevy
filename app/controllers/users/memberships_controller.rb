# frozen_string_literal: true

# 'My groups' section.
class Users::MembershipsController < ApplicationController
  after_action :verify_authorized

  def index
    authorize :user_membership

    @user              = User.find(params[:user_id])
    @owned_groups      = find_owned_groups
    @associated_groups = find_associated_groups
  end

  private

    def find_owned_groups
      UserMembershipDecorator.collection(
        @user.owned_groups.order(:name)
      )
    end

    def find_associated_groups
      UserMembershipDecorator.collection(
        @user.associated_groups.order(:name)
      )
    end
end
