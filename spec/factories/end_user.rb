FactoryBot.define do
  factory :end_user do
    name {"kanako"}
    # email {"kanako@test"}
    email { |n| "tester#{n}@example.com" }
    password {"000000"}
    password_confirmation {"000000"}
  end
end