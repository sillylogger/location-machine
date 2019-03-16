class Setting < ApplicationRecord

  validates_presence_of :name
  validates_presence_of :value

  def self.fetch name, default = nil
    setting = Setting.find_or_create_by(name: name) do |s|
      s.value = default
    end

    return setting.value

  rescue Exception => e
    return default
  end

  def self.get name
    setting = Setting.find_by(name: name)
    return setting.value unless setting.nil?
  end


  # Dry up setting access:
  def self.site_title
    fetch 'site.title', 'Location Machine'
  end

  def self.site_tagline
    fetch 'site.tagline', 'GPS meets Photography meets Messaging'
  end


end
