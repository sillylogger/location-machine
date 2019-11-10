namespace :translation do
  task dup_activerecord_translation_from_en_to_vi: :environment do
    I18n::Backend::ActiveRecord::Translation.where(locale: :en).where('key like ?', 'activerecord%').each do |translation|
      translation = translation.dup
      translation.locale = :vi
      translation.save if translation.valid?
    end
  end
end
