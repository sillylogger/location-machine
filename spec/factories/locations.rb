FactoryBot.define do

  factory :location do
    user
    name          { "Phuong's Sweet Chicken" }
    description   { "Home of the world famous papaya chicken!" }
    longitude     { rand(360) - 180 }
    latitude      { rand(180) -  90 }
    address       { "HaNoi, VietNam" }
  end

end
