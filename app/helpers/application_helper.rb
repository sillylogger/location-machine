module ApplicationHelper

  def icon file, options = {}
    content_tag :svg, class: "#{options[:class]} icon" do
      content_tag :use, 'xlink:href' => asset_path("#{file}.svg#icon-#{file}") do
      end
    end
  end

end
