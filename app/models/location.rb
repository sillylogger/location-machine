class Location < ApplicationRecord
  include ::ImageHelper
  include Rails.application.routes.url_helpers
  include PgSearch

  multisearchable against: [:name, :description], additional_attributes: -> (location) {
    {
      latitude: location.latitude,
      longitude: location.longitude
    }
  }

  attr_accessor :distance
  acts_as_mappable lat_column_name: :latitude,
                   lng_column_name: :longitude

  has_many :items, dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true

  belongs_to :user

  validates_presence_of :user, :latitude, :longitude, :name, :address
  after_save :update_items_coordinate

  scope :for_display, ->() {
    where("latitude IS NOT NULL").
    where("longitude IS NOT NULL").
    where("name <> ''")
  }

  def update_items_coordinate
    items.find_each { |record| record.update_pg_search_document }
  end

  def editor? user
    self.user_id == user&.id
  end

  # TODO: move this to: https://github.com/rails-api/active_model_serializers
  def serializable_hash options=nil
    super({
      include: [:items],
      methods: [:pretty_path],
      except:  [:user_id, :created_at, :updated_at]
    }.merge(options || {}))
  end

  def pretty_path
    location_path(self) if persisted?
  end

  def to_param
    [id, name&.parameterize].compact.join('-')
  end

  def has_image?
    image.present?
  end

  def image
    items.detect { |item| item.has_image? }&.image
  end

  def image_urls
    return unless has_image?

    {
      thumb:  thumb_path(image.service_url),
      medium: medium_path(image.service_url),
      full:   full_path(image.service_url)
    }
  end
end
