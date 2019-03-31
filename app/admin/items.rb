ActiveAdmin.register Item do
  permit_params :location_id, :image, :name, :price, :description

  index do
    selectable_column
    column :id
    column :location do |item|
      item.location.name
    end
    column :image do |item|
      if item.has_image?
        image_tag item.image_urls[:thumb], height: '150px'
      else
        content_tag(:span, '-')
      end
    end
    column :name
    column :price do |item|
      number_to_currency(item.price)
    end
    column :description
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :location
      row :image do
        if item.has_image?
          image_tag item.image_urls[:thumb], height: '150px'
        else
          content_tag(:span, '-')
        end
      end
      row :name
      row :price do
        number_to_currency(item.price)
      end
      row :description
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :location_id, label: "Location Id"

      f.input :image, :hint => f.object.has_image? \
              ? f.image_tag(f.object.image_urls[:thumb], style: 'height: 150px;')
              : f.content_tag(:span, '-'), as: :file

      f.input :name
      f.input :price, as: :string
      f.input :description
    end
    f.actions
  end

end
