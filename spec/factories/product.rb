FactoryBot.define do
  factory :product do
    association :user

    title { Faker::Name.name }
    description { Faker::Name.name }
    external_id { Faker::Name.name }
    price { 10.5 }
  end
end
