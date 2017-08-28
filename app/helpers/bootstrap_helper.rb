# Helper functions to render generic Bootstrap v4 nodes/objects in the DOM
# used in multiple view files.
module BootstrapHelper

  # Div tags for Bootstrap grid system (col-xx-yy)
  %w(xs sm md lg xl).each do |col|
    12.times.each do |i|
      define_method("div_col_#{col}_#{i+1}_tag") do |*args, &block|
        options = Hash(args.extract_options!)
        options[:class] = Array(options[:class]) << "col#{"-#{col}".sub('-xs', '')}-#{i+1}"
        div_tag(*(args+[options]), &block)
      end
    end
  end

  # Usual content tags
  %w(div strong p span nav ul li a table tr td th tbody tfoot thead i b u em dl dt dd small input textarea).each do |custom_tag|
    define_method("#{custom_tag}_tag"){|*args, &block| content_tag(custom_tag, *args, &block)}
  end

  # H tags
  6.times.each{|i| define_method("h#{i+1}_tag"){|*args, &block| content_tag("h#{i+1}", *args, &block)} }

  # Bootstrap div row
  def div_row_tag(*args, &block)
    options = Hash(args.extract_options!)
    options[:class] = Array(options[:class]) << :row
    div_tag(*(args+[options]), &block)
  end

  # Bootstrap simple alert
  def simple_alert_tag(text, status='success')
    return if text.blank?
    div_tag(class: "alert alert-#{status}", role: :alert){ h(text)}
  end

  # Bootstrap alert for model errors
  def alert_tag(instance)
    return unless instance.is_a?(ApplicationRecord) # this function if for active record child classes only.
    return if instance.errors.empty?                # nothing to display
    div_tag(id: "#{instance.class.name.downcase}_errors", class: %w(alert alert-danger), role: :alert) do
      ul_tag do
        safe_join(instance.errors.full_messages.map{ |message| li_tag{ message } })
      end
    end
  end
  
  # Tags
  def br_tag() tag(:br) end
  def hr_tag() tag(:hr) end
  
  # Bootstrap progress bar
  def progress_bar(percentage, status=:success)
    div_tag(
      class: "progress-bar bg-#{status}",
      role: :progress_bar,
      style: "width: #{percentage}%",
      'aria-valuenow': percentage,
      'aria-valuemin': 0,
      'aria-valuemax': 100
    ){ "#{percentage}%" }
  end
  
end