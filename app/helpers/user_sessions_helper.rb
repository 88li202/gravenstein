# User Session helper for the common header part.
module UserSessionsHelper

  # User header
  def user_header(instance, title, notice)
    h1_tag(class: %w(display-3 align-middle)){
      image_tag("#{ApplicationRecord::NAME.downcase}.png", size: '64x64') +
      span_tag(class: %w(align-middle)){ title }
    } +
    p_tag(class: %w(lead)){ t('survey.simple_tool') } +
    tag(:hr, class: %w(my-4)) +
    simple_alert_tag(notice) +
    alert_tag(instance)
  end

end
