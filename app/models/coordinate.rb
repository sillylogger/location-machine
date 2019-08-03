class Coordinate < ApplicationRecord
  validates :latitude, :longitude, presence: true
  belongs_to :user
end
