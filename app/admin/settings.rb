ActiveAdmin.register Setting do
  permit_params :name, :value

  index do
    selectable_column
    id_column
    column :name
    column :value
    column :created_at
    actions
  end

  filter :name
  filter :value
  filter :created_at

  show do
    attributes_table do
      row :name
      row :value
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :value
    end
    f.actions
  end

end
