require 'i18n/backend/active_record'
require "i18n/backend/fallbacks"

I18n.available_locales = [:vi, :id, :en]

I18n.fallbacks.map(vi: :en)
I18n.fallbacks.map(id: :en)

I18n.default_locale = :en

Translation = I18n::Backend::ActiveRecord::Translation
I18n::Backend::ActiveRecord.send(:include, I18n::Backend::ActiveRecord::Missing)
I18n::Backend::ActiveRecord.send(:include, I18n::Backend::Memoize) if Rails.env.production?

I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
I18n::Backend::Simple.send(:include, I18n::Backend::Memoize) if Rails.env.production?

I18n.backend = I18n::Backend::Chain.new(I18n::Backend::ActiveRecord.new,
                                        I18n::Backend::Simple.new)

