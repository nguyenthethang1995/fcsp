module UsersHelper
  def load_user_avatar user, options = {}
    if user.avatar
      image_tag user.avatar.picture, alt: user.name.to_s,
        class: options[:class].to_s,
        size: options[:size].to_s
    else
      image_tag "avatar.jpg", alt: user.name.to_s,
      class: options[:class].to_s, size: options[:size].to_s
    end
  end

  def load_user_cover user, options = {}
    if user.cover_image
      image_tag user.cover_image.picture, alt: user.name.to_s,
        class: options[:class].to_s, size: options[:size]
    else
      image_tag "cover_image_default.jpg", alt: user.name.to_s,
        class: options[:class].to_s, size: options[:size]
    end
  end

  def information_status user, info
    if user.info_user_info_statuses[info.to_sym] ==
      InfoUser::INFO_STATUS[:public]
      content_tag :span, "", class: "icon-globe #{info}-status"
    else
      content_tag :span, "", class: "icon-lock #{info}-status"
    end
  end

  def tms_synchronize_button
    if cookies.signed[:tms_user]
      link_to t(".refresh"), tms_synchronize_index_path,
        class: "btn btn-sm btn-primary synchronize-button"
    end
  end

  def check_permission_profile
    @user.info_user.is_public?
  end

  def load_level skill_user
    skill_user.level ||= Settings.level_range
  end

  def format_skill_years years
    years.to_i == years ? "%i" % years : years
  end
end
