FactoryBot.define do

  sequence :email do |n|
    "#{User::TEMP_EMAIL_PREFIX}-#{n}-facebook.com"
  end

  factory :user do
    email
    password     { "password" }
    name         { "Tommy Sullivan" }
    avatar_url   { "https://graph.facebook.com/10100952355977829/picture" }
    confirmed_at { Time.zone.now }
  end

end

