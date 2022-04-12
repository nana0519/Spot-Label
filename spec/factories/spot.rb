FactoryBot.define do
  factory :spot do
    end_user_id {"1"}
    introduction {Faker::Lorem.characters(number:50)}
    address {"千葉県浦安市舞浜1-1"}
    spot_images {Rack::Test::UploadedFile.new("spec/fixtures/test_image.jpg")}
  end
end