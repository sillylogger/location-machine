class Item < ApplicationRecord
  include Rails.application.routes.url_helpers

  validates_presence_of :name, :price, :description

  belongs_to        :location
  has_one_attached  :image

  def image_url
    rails_blob_path(image, only_path: true)
  end

  # TODO: move this to: https://github.com/rails-api/active_model_serializers
  def serializable_hash options=nil
    super({
      methods: [:image_url],
      except:  [:location_id, :created_at, :updated_at]
    }.merge(options || {}))
  end

end
