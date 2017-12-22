class CoursesController < ApplicationController
  before_action :authenticate_user!
  load_resource :user, id_param: :user_id, parent: false, only: :show
  before_action :check_permission_profile, only: :show
  load_resource through: :user, only: :show

  def show
    @user_course_subjects = @course.user_course_subjects.includes(:subject)
      .check_user @user
    user_shares = @user.user_shares
    user_following = @user.following_users
    @users = {user_shares: user_shares,
      limit_user_shares: user_shares.take(Settings.user.limit_user),
      user_following: user_following,
      limit_user_following: user_following.take(Settings.user.limit_user)}

    if request.xhr?
      render json: {
        status: :success,
        html: render_to_string(partial: "courses/course_details",
          locals: {user: @user, course: @course, subjects: @user_course_subjects},
          layout: false)
      }
    end
  end

  private

  def check_permission_profile
    return if @user.is_user?(current_user) || @user.share?(current_user)
    flash[:alert] = t ".page_error"
    redirect_to root_path
  end
end
