class CoursesController < ApplicationController
  include CheckPermissionProfile

  before_action :authenticate_user!
  load_resource :user, id_param: :user_id, parent: false, only: :show

  before_action only: :show do
    check_permission_profile @user
  end

  load_resource through: :user, only: :show

  def show
    @user_course_subjects = @course.user_course_subjects.includes(:subject)
      .check_user @user
    user_shares = @user.user_shares.includes :avatar
    user_following = @user.following_users.includes :avatar
    @users = {user_shares: user_shares,
      limit_user_shares: user_shares.take(Settings.user.limit_user),
      user_following: user_following,
      limit_user_following: user_following.take(Settings.user.limit_user)}

    if request.xhr?
      render json: {
        status: :success,
        html: render_to_string(
          partial: "courses/course_details",
          locals: {user: @user, course: @course,
            subjects: @user_course_subjects}, layout: false
        )
      }
    end
  end
end
