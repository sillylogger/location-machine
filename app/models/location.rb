class Location < ApplicationRecord
  include Rails.application.routes.url_helpers

  validates_presence_of :user, :latitude, :longitude, :name

  belongs_to :user

  has_many   :items, dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true

  scope :for_display, ->() {
    where("latitude IS NOT NULL").
    where("longitude IS NOT NULL").
    where("name <> ''")
  }
  scope :newest, -> { order(created_at: :desc) }
  scope :in_bounds, ->(sw_lat, sw_lng, ne_lat, ne_lng) do
    where (
      <<-EOS.squish
        ((:sw_lat < :ne_lat AND latitude BETWEEN :sw_lat AND :ne_lat) OR (:ne_lat < :sw_lat AND latitude BETWEEN :ne_lat AND :sw_lat))
        AND
        ((:sw_lng < :ne_lng AND longitude BETWEEN :sw_lng AND :ne_lng) OR (:ne_lng < :sw_lng AND longitude BETWEEN :ne_lng AND :sw_lng))
      EOS
    ), sw_lat: sw_lat, sw_lng: sw_lng, ne_lat: ne_lat, ne_lng: ne_lng
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

end
