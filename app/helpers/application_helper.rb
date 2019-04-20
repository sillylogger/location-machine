module ApplicationHelper

  def icon file, options = {}
    content_tag :svg, class: "#{options[:class]} icon" do
      content_tag :use, 'xlink:href' => asset_path("#{file}.svg#icon-#{file}") do
      end
    end
  end

  def home_link
    link_to(root_url) do
      if Setting.site_logo_masthead.present?
        image_tag Setting.site_logo_masthead, class: 'homepage__logo'
      else
        content_tag :span, Setting.site_title, class: 'homepage__title'
      end
    end
  end
end
