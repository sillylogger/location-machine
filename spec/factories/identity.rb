FactoryBot.define do
  factory :identity do
    provider { 'facebook' }
    uid { "123456-#{rand(1.1000)}" }
    user
  end
end
