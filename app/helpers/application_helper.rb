module ApplicationHelper

  def icon file, options = {}
    content_tag :svg, class: "#{options[:class]} icon" do
      content_tag :use, 'xlink:href' => asset_path("#{file}.svg#icon-#{file}") do
      end
    end
  end

  def home_link
    link_to(root_url) do
      concat image_tag Setting.site_logo, class: 'homepage__logo'
      concat content_tag :span, Setting.site_title, class: 'homepage__title'
    end
  end
end
