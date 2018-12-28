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

  show do
    attributes_table do
      row :title
      row :path
      row :content do |page|
        FormatHelper.markdownify page.content
      end
      row :visibility
      row :published
      row :created_at
      row :updated_at
    end
  end

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
