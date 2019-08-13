class Item < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to        :location
  acts_as_mappable  through: :location
  delegate :latitude, :longitude, to: :location, allow_nil: true

  include ::ImageHelper
  has_one_attached  :image, acl: 'public'

  include PgSearch
  multisearchable against: [:name, :description], additional_attributes: -> (item) {
    {
      latitude: item.latitude,
      longitude: item.longitude
    }
  }

  scope :latest_in_distance, -> (origin, distance: Setting.site_location_radius) {
    joins(:location)
      .within(distance, origin: origin)
      .latest
  }

  scope :latest, -> { order(created_at: :desc) }

  attr_accessor :distance

  validates_presence_of :name

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

  def pretty_path
    location_item_path(location, self) if persisted?
  end

  def to_param
    [id, name&.parameterize].compact.join('-')
  end
end
