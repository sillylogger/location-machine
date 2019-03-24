ActiveAdmin.register Translation, as: "Translation" do

  scope("App Specific", default: true) { |scope| scope.where("key like 'lm%'") }
  scope("All")                         { |scope| scope }

  permit_params :locale, :key, :value

  index do
    selectable_column
    column :id
    column :locale
    column :key
    column :value
    column :interpolations
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :locale,         as: :select,
                               collection: I18n.available_locales
      f.input :key,            as: :string
      f.input :value,          as: :string
    end
    f.actions
  end

end
