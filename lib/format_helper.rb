class FormatHelper

  def self.date value
    return '' if value.nil?
    value.strftime('%B %-d, %Y').strip
  end

  def self.link url, options = {}
    return '' if url.nil?

    pretty_url = url
    pretty_url = pretty_url.sub(%r(https?://), '')
    pretty_url = pretty_url.sub(%r(www.), '') unless options[:leave_www]

    options[:target] ||= '_blank'
    options[:rel] ||= 'nofollow'

    ActionController::Base.helpers.link_to pretty_url, url, options
  end

  def self.mail address
    return '' if address.nil?
    pretty_address = address.sub('@kmkonline.co.id', '')
    ActionController::Base.helpers.mail_to address, pretty_address
  end

  def self.tel number
    return '' if number.nil?
    ActionController::Base.helpers.link_to number, "tel:#{number}"
  end

  def self.host url
    uri = URI.parse url
    uri.host
      .sub('www.','')
      .sub('.com','')
      .titlecase
  end

  def self.markdownify source, options = {}
    renderer = Redcarpet::Render::HTML.new filter_html: true, hard_wrap: true
    markdown = Redcarpet::Markdown.new renderer, autolink: true

    source ||= ""
    css_classes = [options[:class], 'b-markdown'].compact.join(' ')
    ActionController::Base.helpers.content_tag(:div, class: css_classes) do
      markdown.render(source).html_safe
    end
  end

end
