class Item < ApplicationRecord

  validates_presence_of :name, :price, :description

  belongs_to :location

end
