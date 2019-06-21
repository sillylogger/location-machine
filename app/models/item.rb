class Item < ApplicationRecord
  include ::ImageHelper
  include PgSearch

  validates_presence_of :name

  belongs_to        :location
  has_one_attached  :image, acl: 'public'

  pg_search_scope :search_for, against: %i(name description)

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
    return unless has_image?

    {
      thumb:  thumb_path(image.service_url),
      medium: medium_path(image.service_url),
      full:   full_path(image.service_url)
    }
  end

  def price= value
    super Monetize.parse(value).amount
  end

  def has_image?
    image.attached?
  end

  def to_param
    [id, name&.parameterize].compact.join('-')
  end

end
