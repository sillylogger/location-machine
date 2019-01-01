class Location < ApplicationRecord

  validates_presence_of :name, :description

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
      except:  [:user_id, :created_at, :updated_at]
    }.merge(options || {}))
  end

end
