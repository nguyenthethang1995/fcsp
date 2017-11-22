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

  def org_logo org
    company = Company.find_by name: org.name
    if company.present? && company.images.first.present?
      @company.images.first
    else
      Settings.user_works.org_avatar
    end
  end

  def work_status_select
    UserWork.statuses.keys.map{|status| [t(".all_status.#{status}"), status]}
  end

  def language_level_select
    UserLanguage.levels
      .map{|status, _| [t(".levels.#{status}"), status]}
  end

  def suggest_friend user, friend
    friend_of_friends = friend.list_friends
    if user.friends.include?(friend) &&
      current_user.friends.include?(friend) || friend == current_user
      content_tag :a, href: "#", "data-toggle": "modal", class: "friend",
        "data-target": "#modal_friend-#{friend.id}", "data-whatever": "@mdo" do
        friend_of_friends.size.to_s << " " << t(".friends")
      end
    else
      content_tag :a, href: "#", "data-toggle": "modal", class: "friend",
        "data-target": "#modal_mutual_friend-#{friend.id}",
        "data-whatever": "@mdo" do
        current_user.mutual_friends_in_lists(friend_of_friends)
          .size.to_s << " " <<  t(".mutual_friends")
      end
    end
  end

  def check_add_friend user, friend
    if user.friends.include?(friend) &&
      current_user.friends.include?(friend) || friend == current_user
      btn_request friend unless friend.is_user? current_user
    else
      btn_request friend
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
      link_to t(".refresh"), tms_synchronize_index_path, class: "btn btn-default synchronize-button"
    end
  end

  def check_permission_profile
    @user.info_user.is_public?
  end

  def load_level skill_user
    skill_user.level ||= Settings.level_range
  end

  def input_date form, object, attribute
    if object.send attribute
      form.text_field attribute,
        value: l(object.send(attribute), format: :short_month_year),
        class: "form-control input-date"
    else
      form.text_field attribute,
        class: "form-control input-date"
    end
  end

  def select_user_role
    User.roles.keys.reject!{|n| n == "admin"}
  end
end
