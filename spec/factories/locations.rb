FactoryBot.define do

  factory :location do
    user
    name          { "Sweet Chicken" }
    description   { "Home of the world famous papaya chicken!" }
    longitude     { rand(360) - 180 }
    latitude      { rand(180) -  90 }
  end

end

