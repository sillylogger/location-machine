FactoryGirl.define do

  factory :party do
    name          "basement"
    description   "bring a bottle"
    opens         { 6.hours.ago }
    closes        { 6.hours.from_now }
  end

end

