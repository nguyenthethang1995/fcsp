class UserCoversController < ApplicationController
  before_action :authenticate_user!

  def create
    if params[:image].blank?
      flash[:danger] = t "user_avatars.you_didnt_choose"
      redirect_to edit_user_path current_user
    else
      image = current_user.images.build cover_params

      if image.save && current_user.update(cover_image_id: image.id)
        flash[:success] = t ".success"
        redirect_to user_path current_user
      else
        flash[:danger] = t ".fail"
        redirect_to edit_user_path current_user
      end
    end
  end

  def update
    if params[:image][:picture].blank?
      flash[:danger] = t "user_avatars.you_didnt_choose"
      redirect_to edit_user_path current_user
    else
      if current_user.update cover_image_id: cover_params[:picture]
        flash[:success] = t ".success"
        redirect_to user_path current_user
      else
        flash[:danger] = t ".fail"
        redirect_to edit_user_path current_user
      end
    end
  end

  private

  def cover_params
    params.require(:image).permit :picture
  end
end
