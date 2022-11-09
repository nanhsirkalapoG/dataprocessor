FactoryBot.define do
  factory :product do
    association :user

    title { Faker::Name.name }
    description { Faker::Name.name }
    external_id { Faker::Name.name }
    price { 10.5 }

    trait :custom_fields do
      after(:create) do |product|
        2.times { FactoryBot.create(:custom_field, customizable: product) }
      end
    end
  end
end
