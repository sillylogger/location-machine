class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.string :title
      t.string :path
      t.text :content
      t.string :visibility
      t.boolean :published

      t.timestamps
    end
  end
end
