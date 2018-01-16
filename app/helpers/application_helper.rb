module ApplicationHelper
  def full_title page_title = ""
    base_title = t "title"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def not_found
    render file: "public/404.html", layout: false, status: 404
  end

  def check_paginator? page
    page.left_outer? || page.right_outer? || page.inside_window?
  end

  def view_object name
    if name.is_a?(Symbol)
      class_name = name.to_s.titleize.split(" ").join("")
    else
      class_name = name.split("/")
        .map{|name_split| name_split.titleize.sub(" ", "")}.join("::")
    end
    class_name.constantize.new(self)
  end

  def devise_mapping
    Devise.mappings[:user]
  end

  def is_warning_flash? message_type
    message_type == Settings.warning
  end

  def is_notice_flash? message_type
    %w(success notice).include? message_type
  end

  private

  def format_time time, format
    I18n.l time, format: format if time
  end

  def class_hidden object
    "hidden" if object.blank?
  end

  def status_color status
    case status
    when Settings.courses.status.init then "label label-warning"
    when Settings.courses.status.in_progress then "label label-success"
    when Settings.courses.status.finished then "label label-danger"
    else "label label-default"
    end
  end
end
