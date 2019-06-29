class Item < ApplicationRecord
  include ::ImageHelper
  include PgSearch

  validates_presence_of :name

  belongs_to        :location
  has_one_attached  :image, acl: 'public'
  acts_as_mappable through: :location

  pg_search_scope :search_for, against: %i(name description)

  delegate :latitude, :longitude, to: :location, allow_nil: true

  attr_accessor :distance

  # TODO: default is 50 kilometers, we need to find a suitable number later
  scope :for_nearests, -> (origin, text: '', distance: 50) {
    scoped = joins(:location).within(50, origin: origin).by_distance(origin: origin)
    scoped = scoped.search_for(text) if text.present?
    scoped
  }

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
