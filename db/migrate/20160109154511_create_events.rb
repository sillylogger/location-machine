class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.text :description
      t.datetime :opens
      t.datetime :closes
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
