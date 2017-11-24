class Setting::ProfilesController < Setting::BaseController
  def index
    @users = User.user_all current_user.id
    @limit_users = current_user.user_shares.includes(:avatar)
  end
end
