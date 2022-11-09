FactoryBot.define do
  factory :custom_field do
    association :customizable

    field_name { Faker::Name.name }
    value { Faker::Name.name }
    data_type { 'string' }
  end
end
