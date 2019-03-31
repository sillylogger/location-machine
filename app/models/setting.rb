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

    setting.has_attachment? ? setting.attachment_url : setting.value
  rescue Exception
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

  def self.site_logo
    fetch 'site.logo', 'Logo of site', {
      io: File.open(Rails.root.join('app', 'assets', 'images', 'logo.png')), filename: 'logo.png'
    }
  end

  def self.site_currency
    fetch 'site.currency', 'USD'
  end

  def has_attachment?
    attachment.attached?
  end

  def is_image_attached?
    has_attachment? && attachment.content_type.include?('image')
  end

  def attachment_url
    is_image_attached? ? full_path(attachment.service_url) : attachment.service_url
  end
end
