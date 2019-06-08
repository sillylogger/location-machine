ActiveAdmin.register Location do

  menu priority: 10

  permit_params :user_id, :name, :description, :latitude, :longitude, :address

  index do
    selectable_column
    column :id
    column :user do |location|
      location.user.name
    end
    column :name
    column :address
    column :items do |location|
      link_to location.items.count, admin_items_path(q: { location_id_in: location.id })
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :user
      row :name
      row :address
      row :description
      row :latitude
      row :longitude
      row :items do
        link_to location.items.count, admin_items_path(q: { location_id_in: location.id })
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :user_id, label: "User Id"

      f.input :address
      f.input :name
      f.input :description

      f.input :latitude
      f.input :longitude
    end
    f.actions
  end

end
