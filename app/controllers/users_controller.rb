class UsersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :authenticate_tms
  before_action :is_employer?, only: %i(show follow unfollow)
  load_and_authorize_resource
  skip_authorization_check only: :show
  autocomplete :skill, :name, full: true

  def show
    user_shares = @user.user_shares.includes :avatar
    user_following = @user.following_users.includes :avatar
    @users = {user_shares: user_shares,
      limit_user_shares: user_shares.take(Settings.user.limit_user),
      user_following: user_following,
      limit_user_following: user_following.take(Settings.user.limit_user)}
    @advance_profiles = {schools: @user.schools,
      skills: @user.skill_users.includes(:skill),
      languages: @user.user_languages.includes(:language),
      courses: @user.courses.includes(:programming_language)}
    @trainees = User.includes(:avatar, :info_user).trainee.page(params[:page])
      .per Settings.users.show.trainees_per_page
    if request.xhr?
      render json: {
        trainees: render_to_string(partial: "users/trainees", layout: false),
        paginate_trainees: render_to_string(partial: "users/paginate_trainees", layout: false)
      }
    end
  end

  def edit
    @info_user = current_user.info_user
    @skill = Skill.new
    @skills = current_user.skill_users.includes :skill
  end

  def update
    if current_user.update_attributes "#{params[:type]}": params[:input_info_user]
      user_attribute = User.pluck_params_type params[:id], params[:type]
      render json: {html: render_to_string(partial: "users/type",
        locals: {info_user: user_attribute}, layout: false), info_status: "success",
        html_site_name: render_to_string(partial: "users/type_site_name",
          layout: false)}
    else
      render json: {message: current_user.errors.full_messages}
    end
  end

  def update_auto_synchronize
    if current_user.update_attributes auto_synchronize: params[:auto_synchronize]
      flash[:success] = t "users.update.auto_synchronize_success"
    else
      flash[:error] = t "users.update.auto_synchronize_error"
    end
    redirect_to setting_root_path
  end

  def follow
    @object.follow @user
    render json: {
      html: render_to_string(partial: "follow_user", layout: false, locals: {user: @user})
    }
  end

  def unfollow
    @object.stop_following @user
    render json: {
      html: render_to_string(partial: "follow_user", layout: false, locals: {user: @user})
    }
  end

  private

  def is_employer?
    if user_signed_in? && current_user.employer? && current_user.company_id
      @object = Company.find_by id: current_user.company_id
    else
      @object = current_user
    end
  end
end
