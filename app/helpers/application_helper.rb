module ApplicationHelper
  def show_messages
    result = ActiveSupport::SafeBuffer.new

    flash.each do |key, message|
      next unless message.is_a? String

      result << create_flash_tag(key, message)
    end
    result
  end

  private

  def create_flash_tag(key, message)
    content = if key.ends_with?('_html')
                sanitize message
              else
                message.to_str
              end

    css_class = case key
                when /\Aalert/
                  'danger'
                when /\Anotice/
                  'info'
                else
                  'secondary'
                end

    content_tag :div, content, class: "alert alert-#{css_class}"
  end

  def create_link(name, link)
    linkdata = link_to name, link, target: '_blank'

    if /\Ahttps:\/\/gist.github.com\/[^\/]+\/[0-9a-f].*\z/.match link
      content_tag :script, "", src: "#{link}.js"
    else
      linkdata
    end
  end
end
