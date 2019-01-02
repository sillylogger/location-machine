class Setting < ApplicationRecord

  validates_presence_of :name
  validates_presence_of :value

  def self.fetch name, default = nil
    setting = Setting.find_or_create_by(name: name) do |s|
      s.value = default or raise KeyError.new("No setting found for #{name} and no default given.")
    end

    setting.value
  end

end
