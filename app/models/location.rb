class Location < ApplicationRecord

  validates_presence_of :name, :description

  belongs_to :user
  has_many   :items

end
