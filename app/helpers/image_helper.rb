module ImageHelper
  include ::CloudinaryHelper

  def thumb_path url
    image_path(url, {
      width: 150,
      height: 150,
      crop: :fill
    })
  end

  def medium_path url
    image_path(url, {
      width: 614,
      height: 614,
      crop: :fill
    })
  end

  def full_path url
    image_path(url, {
      quality: 95,
      width: 1080,
      crop: :scale
    })
  end

  def image_path url, options = {}
    return url if [:test, :local].include?(Rails.application.config.active_storage.service) ||
                  (Credential.fetch(:cloudinary, :cloud_name) == 'demo')

    cl_image_path(url, {
      secure: true,
      type: :fetch,
      fetch_format: :auto,
      quality: 85,
      effect: :improve
    }.merge(options))
  end

end
