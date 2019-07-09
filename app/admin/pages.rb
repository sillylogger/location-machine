ActiveAdmin.register Page do
  
  menu priority: 25

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

    active_admin_comments

    panel "Versions" do
      paginated_collection(resource.versions.page(params[:version_page]).per(20), param_name: 'version_page', download_links: false) do
        table_for collection do
          column :id
          column :event
          column :whodunnit
          column :changeset do |version|
            version.changeset.except('updated_at')
          end
          column :created_at
        end
      end
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
