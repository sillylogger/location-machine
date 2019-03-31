module SettingsHelper
  def attachment_tag(setting)
    if setting.has_attachment?
      if setting.is_image_attached?
        image_tag setting.attachment_url, height: '150px'
      else
        link_to 'Download', setting.attachment_url
      end
    else
      'None'
    end
  end
end
