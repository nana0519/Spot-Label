FactoryBot.define do
  factory :end_user do
    name {Faker::Name.name}
    email {Faker::Internet.unique.email}
    password {"000000"}
    password_confirmation {"000000"}
  end
end