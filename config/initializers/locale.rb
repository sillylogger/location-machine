require 'i18n/backend/active_record'
require "i18n/backend/fallbacks"

I18n.available_locales = [:vi, :id, :en]

I18n.fallbacks.map(vi: :en)
I18n.fallbacks.map(id: :en)

I18n.default_locale = :en

Translation = I18n::Backend::ActiveRecord::Translation
I18n::Backend::ActiveRecord.send(:include, I18n::Backend::ActiveRecord::Missing)
I18n::Backend::ActiveRecord.send(:include, I18n::Backend::Memoize)

I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
I18n::Backend::Simple.send(:include, I18n::Backend::Memoize)

I18n.backend = I18n::Backend::Chain.new(I18n::Backend::ActiveRecord.new,
                                        I18n::Backend::Simple.new)


module I18n
  module Backend
    class ActiveRecord
      class Translation < ::ActiveRecord::Base
        after_save :reload_i18n

        private
        def reload_i18n
          I18n.backend.reload!
        end
      end
    end
  end
end
