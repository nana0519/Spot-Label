FactoryBot.define do
  factory :spot do
    end_user
    introduction {Faker::Lorem.characters(number:50)}
    address {"千葉県浦安市舞浜1-1"}
   after :build do |spot|
      spot.spot_images.attach(io:File.open(Rails.root.join('spec/fixtures/test_image.jpg')),filename: 'user.jpg') 
   end
  end
end