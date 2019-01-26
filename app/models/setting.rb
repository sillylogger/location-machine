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


  # BEGIN: Manually bring in ActiveStorage from my hacked config/initializers/active_storage.rb 
  # to avoid the database loading issues

    def image
      @active_storage_attached_image ||= ActiveStorage::Attached::One.new("image", self, dependent: :purge_later, acl: :public)
    end

    def image= attachable
      image.attach(attachable)
    end

    has_one :image_attachment, -> { where(name: :image) }, class_name: "ActiveStorage::Attachment", as: :setting, inverse_of: :setting, dependent: false
    has_one :image_blob, through: :image_attachment, class_name: "ActiveStorage::Blob", source: :blob

    # scope :"with_attached_#{name}", -> { includes("#{name}_attachment": :blob) }

    after_destroy_commit do
      if has_image?
        image.purge_later
      end
    end

  # END: Manually bring in ActiveStorage from my hacked config/initializers/active_storage.rb 

end
