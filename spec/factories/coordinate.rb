FactoryBot.define do
  factory :coordinate do
    latitude { rand(0.0..20.0) }
    longitude { rand(0.0..100.0) }
  end
end

