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
        concat image_tag Setting.site_logo_masthead, class: 'navbar__logo'
      end
      concat content_tag :span, Setting.site_title, class: 'navbar__title'
    end
  end
end
