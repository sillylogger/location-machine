FactoryBot.define do

  factory :item do
    location
    name          { "Papaya Chicken" }
    price         { "14500" }
    description   { "Each dish is made with 1 papaya and 2 chicken legs, mmmmm :-)" }

    trait :with_image do
      after :create do |item|
        file_path = Rails.root.join('spec', 'fixtures', 'spring-rolls.jpg')

        item.image.attach(
          io: File.open(file_path),
          filename: 'spring-rolls.jpg',
          content_type: 'image/jpg',
        )
      end
    end
  end

end

