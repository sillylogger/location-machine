module SettingsHelper

  def attachment_tag(setting)
    if setting.has_attachment?
      if setting.has_image_attached?
        image_tag setting.url
      else
        link_to 'Download', setting.url
      end
    else
      'None'
    end
  end

end
