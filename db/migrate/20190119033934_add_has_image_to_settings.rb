class AddHasImageToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :has_image, :boolean
  end
end
