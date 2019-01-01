class Item < ApplicationRecord
  include ::CloudinaryHelper
  include Rails.application.routes.url_helpers

  validates_presence_of :name, :price, :description

  belongs_to        :location
  has_one_attached  :image, acl: 'public'

  def image_urls
    if image.attached?
      {
        thumb:  cl_image_path(
                  image.attachment.blob.service_url, type: :fetch, secure: true,
                  fetch_format: :auto,
                  quality: 85,
                  effect: :improve,
                  width: 150,
                  height: 150,
                  crop: :fill),

        medium:  cl_image_path(
                  image.attachment.blob.service_url, type: :fetch, secure: true,
                  fetch_format: :auto,
                  quality: 85,
                  effect: :improve,
                  width: 614,
                  height: 614,
                  crop: :fill),

        full:  cl_image_path(
                  image.attachment.blob.service_url, type: :fetch, secure: true,
                  fetch_format: :auto,
                  quality: 95,
                  effect: :improve,
                  width: 1080,
                  crop: :scale)
      }
    end
  end

  # TODO: move this to: https://github.com/rails-api/active_model_serializers
  def serializable_hash options=nil
    super({
      methods: [:image_urls],
      except:  [:location_id, :created_at, :updated_at]
    }.merge(options || {}))
  end

end
