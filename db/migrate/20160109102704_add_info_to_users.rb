class AddInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name,       :string

    add_column :users, :avatar,     :string
    add_column :users, :avatar_url, :string

    add_column :users, :phone,      :string
  end
end
