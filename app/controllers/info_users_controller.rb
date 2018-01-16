class InfoUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_info_user, only: %i(index update)
  before_action :check_valid_param_type, only: :update

  def update
    if @info_user.update_attributes info_user_params
      type_update = info_user_params.keys.first
      value_update = info_user_params[type_update]
      render json: {html: value_update, info_status: "success", type: type_update}
    else
      render json: {message: @info_user.errors.full_messages}
    end
  end

  private

  def info_user_params
    params.require(:info_user).permit :relationship_status, :introduction,
      :quote, :ambition, :phone, :address, :gender, :occupation,
      :birthday, :country
  end

  def check_valid_param_type
    updatable_attributes = %w(relationship_status introduction quote ambition
      phone address gender occupation birthday country)

    return if updatable_attributes.include? info_user_params.keys.first
    render json: {message: t("params_error")}
  end

  def find_info_user
    @info_user = current_user.info_user
    return if @info_user
    flash[:danger] = t ".info_user_not_found"
    redirect_to root_url
  end
end
