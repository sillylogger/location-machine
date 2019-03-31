FactoryBot.define do

  sequence :email do |n|
    "#{User::TEMP_EMAIL_PREFIX}-#{n}-facebook.com"
  end

  sequence :phone do |n|
    "+62-812-0000-#{ n.to_s.rjust(4, "0") }"
  end

  factory :user do
    name          { "Tommy Sullivan" }
    email
    phone
    password      { "password" }
    avatar_url    { "https://graph.facebook.com/10100952355977829/picture" }
    confirmed_at  { Time.zone.now }

    trait :with_admin do
      role        { User::ROLES[:admin] }
    end
  end

  factory :facebook_user, parent: :user do
    after :create do |user|
      create_list :identity, 1, user: user
    end
  end
end

