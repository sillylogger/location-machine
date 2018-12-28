ActiveAdmin.register Page do
  permit_params :title, :path, :content, :visibility, :published

  index do
    selectable_column
    id_column
    column :title
    column :path
    column :visibility
    column :published
    actions
  end

  filter :title
  filter :path
  filter :content
  filter :published
  filter :created_at

  form do |f|
    f.inputs do
      f.input :title
      f.input :path
      f.input :content
      f.input :visibility, collection: Page::VISIBILITY.values
      f.input :published
    end
    f.actions
  end

end
