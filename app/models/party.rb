class Party < ActiveRecord::Base

  belongs_to :user

  scope :active, -> { where("opens < :now AND closes > :now", now: Time.zone.now) }

  before_create :set_default_duration

  private

  def set_default_duration
    self.opens ||= Time.zone.now
    self.closes ||= 24.hours.from_now
  end

end
