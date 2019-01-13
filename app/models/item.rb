class Item < ApplicationRecord
  include ::ImageHelper

  validates_presence_of :name

  belongs_to        :location
  has_one_attached  :image, acl: 'public'

  def editor? user
    return false unless self.location.present?
    self.location.user_id == user&.id
  end

  # TODO: move this to: https://github.com/rails-api/active_model_serializers
  def serializable_hash options=nil
    super({
      methods: [:image_urls],
      except:  [:location_id, :created_at, :updated_at]
    }.merge(options || {}))
  end

  def image_urls
    if image.attached?
      {
        thumb:  thumb_path(image.service_url),
        medium: medium_path(image.service_url),
        full:   full_path(image.service_url)
      }
    end
  end

  def to_param
    [id, name&.parameterize].compact.join('-')
  end

end
