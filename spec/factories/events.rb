FactoryGirl.define do

  factory :event do
    name          "basement"
    description   "bring a bottle"
    opens         { 6.hours.ago }
    closes        { 6.hours.from_now }
  end

end

