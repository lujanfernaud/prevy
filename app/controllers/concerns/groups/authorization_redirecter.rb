# frozen_string_literal: true

module Groups::AuthorizationRedirecter
  extend ActiveSupport::Concern

  included do
    before_action :redirect_not_authorized_users
  end

  protected

    def redirect_not_authorized_users
      return if invited_to_group?

      if !current_user
        redirect_to new_user_session_path
      elsif current_user && not_in_group?
        flash[:notice] = you_need_to_be_a_member
        redirect_to root_path
      end
    end

    def invited_to_group?
      return false if session[:token].blank?

      GroupInvitation.find_by(group: _group, token: session[:token])
    end

    def _group
      if controller_path == "events/attendees"
        @_event ||= Event.find(params[:event_id])
        @_group ||= @_event.group
      else
        @_group ||= Group.find(params[:group_id])
      end
    end

    def not_in_group?
      _group.owner != current_user && !_group.members.include?(current_user)
    end

    def you_need_to_be_a_member
      "You need to be a member of #{_group.name} to see that resource."
    end
end
