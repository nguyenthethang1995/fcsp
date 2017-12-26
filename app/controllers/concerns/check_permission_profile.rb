module CheckPermissionProfile
  private

  def check_permission_profile user
    return if user.is_user?(current_user) || user.share?(current_user)
    flash[:alert] = t "page_error"
    redirect_to root_path
  end
end
