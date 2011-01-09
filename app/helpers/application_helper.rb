module ApplicationHelper
  def show_tip_message
    messages = []
    flash.each do |type, message|
      messages << content_tag(:div, message, :class => type)
    end
    messages.join("").html_safe
  end

  def breadcrumb(*value)
    content_tag(:div, value.join(" › "), :class => "breadcrumb")
  end
end