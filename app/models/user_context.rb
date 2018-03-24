class UserContext
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end
end
