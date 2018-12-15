class Identity < ApplicationRecord

  belongs_to :user

  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth auth
    where(uid: auth.uid, provider: auth.provider).first_or_create
  end

end
