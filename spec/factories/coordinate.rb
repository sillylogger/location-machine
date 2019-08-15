FactoryBot.define do
  factory :coordinate do
    user
    latitude { rand(0.0..20.0) }
    longitude { rand(0.0..100.0) }
  end
end

