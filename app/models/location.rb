class Location < ApplicationRecord
  include Rails.application.routes.url_helpers

  validates_presence_of :user

  belongs_to :user
  has_many   :items

  scope :for_display, ->() {
    where("name <> ''").
    where("description <> ''").
    where("latitude IS NOT NULL").
    where("longitude IS NOT NULL")
  }

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
