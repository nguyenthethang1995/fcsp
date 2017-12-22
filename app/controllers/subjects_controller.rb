class SubjectsController < ApplicationController
  before_action :authenticate_user!
  load_resource :user, id_param: :user_id, parent: false, only: :show
  load_resource :course, id_param: :course_id, through: :user, parent: false, only: :show
  load_resource :user_course_subject, through: :user, parent: false, only: :show

  def show
    @user_tasks = @user.user_tasks.includes(:task)
      .check_course_subject params[:course_id], @user_course_subject.subject_id
    user_shares = @user.user_shares
    user_following = @user.following_users
    @users = {user_shares: user_shares,
      limit_user_shares: user_shares.take(Settings.user.limit_user),
      user_following: user_following,
      limit_user_following: user_following.take(Settings.user.limit_user)}

    if request.xhr?
      render json: {
        status: :success,
        html: render_to_string(
          partial: "subjects/subject_details",
          locals: {user: @user, course: @course, subject: @user_course_subject,
            tasks: @user_tasks}, layout: false)
      }
    end
  end
end
