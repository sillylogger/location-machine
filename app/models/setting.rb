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

end