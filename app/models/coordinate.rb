class Coordinate < ApplicationRecord
  validates :latitude, :longitude, presence: true
  belongs_to :user

  def to_latlng
    [latitude, longitude]
  end
end
