class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :location, foreign_key: true
      t.string :name
      t.money :price
      t.text :description

      t.timestamps
    end
  end
end
