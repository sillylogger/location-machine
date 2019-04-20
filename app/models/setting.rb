class Setting < ApplicationRecord
  include ::ImageHelper

  validates_presence_of :name
  validates_presence_of :value

  has_one_attached :attachment, acl: 'public'

  def self.fetch name, default = nil, attachment_options = {}
    setting = Setting.find_or_create_by(name: name) do |s|
      s.value = default
      if attachment_options.present?
        s.attachment.attach(attachment_options)
      end
    end

    setting.has_attachment? ? setting.url : setting.value
  rescue Exception
    return default
  end

  def self.get name
    setting = Setting.find_by(name: name)
    return setting.value unless setting.nil?
  end

  def self.set name, value
    setting = Setting.find_by(name: name)
    if setting.nil?
      Setting.fetch name, value
    else 
      setting.update(value: value)
    end
  end

  # Dry up setting access:
  def self.site_title
    fetch 'site.title', 'Location Machine'
  end

  def self.site_tagline
    fetch 'site.tagline', 'GPS meets Photography meets Messaging'
  end

  def self.site_custom_html
    fetch('site.custom-html', '').html_safe
  end

  def self.site_logo
    fetch 'site.logo', nil, {
      io: File.open(Rails.root.join('app', 'assets', 'images', 'logo.png')), filename: 'logo.png'
    }
  end

  def self.site_logo_masthead
    fetch 'site.logo-masthead', nil, {
      io: File.open(Rails.root.join('app', 'assets', 'images', 'logo-masthead.png')), filename: 'logo-masthead.png'
    }
  end

  def self.site_currency
    fetch 'site.currency', 'USD'
  end

  def has_attachment?
    attachment.attached?
  end

  def url
    attachment.service_url
  end
end
