class ChangeCoordinatorsToCoordinates < ActiveRecord::Migration[5.2]
  def change
    rename_table :coordinators, :coordinates
  end
end
