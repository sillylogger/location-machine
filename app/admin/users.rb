ActiveAdmin.register User do

  menu priority: 90
  actions :all, except: [:destroy]
  permit_params :name, :email, :phone, :role, :avatar_url

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name

      f.input :email
      f.input :phone

      f.input :role,
        as: :select,
        collection: User::ROLES.map{|sym, str| [str, str]}

      f.input :avatar_url
    end
    f.actions
  end

  show title: ->(user) { user.name } do
    columns do
      column do
        attributes_table do
          row :name
          row :email
          row :phone 
          row :role
          row :avatar_url do
            if user.avatar_url.present?
              image_tag user.avatar_url
            end
          end
        end
      end
      column do
        attributes_table do
          row :sign_in_count
          row :failed_attempts

          row :current_sign_in_at
          row :last_sign_in_at 

          row :current_sign_in_ip
          row :last_sign_in_ip

          row :confirmed_at
          row :confirmation_sent_at
          row :unconfirmed_email
        end
      end
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

end
