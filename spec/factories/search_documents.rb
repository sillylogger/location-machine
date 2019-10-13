FactoryBot.define do
  factory :search_document do
    content { "Papaya Chicken Each dish is made with 1 papaya and 2 chicken legs, mmmmm :-)" }
  end

  trait :location do
    association :searchable, factory: :location
  end

  trait :item do
    association :searchable, factory: :item
  end
end

