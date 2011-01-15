module ApplicationHelper
  def avatar_url(email)
    default_url = "#{root_url}images/guest.png"
    gravatar_id = Digest::MD5::hexdigest(email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
  end

  def show_tip_message
    messages = []
    flash.each do |type, message|
      messages << content_tag(:div, message, :class => type)
    end
    messages.join("").html_safe
  end

  def breadcrumb(*value)
    # &raquo;
    content_tag(:div, value.join(" › "), :class => "breadcrumb")
  end
end
