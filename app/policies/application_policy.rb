# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :context, :record, :user, :params

  def initialize(context, record)
    @context = context
    @record  = record
  end

  delegate :user,   to: :context
  delegate :params, to: :context

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def logged_in?
    user
  end

  def params_user
    User.find(params[:user_id])
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
