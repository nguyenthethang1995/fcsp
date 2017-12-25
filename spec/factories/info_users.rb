FactoryBot.define do
  factory :info_user do
    relationship_status 0
    introduction FFaker::Lorem.paragraph
    birthday FFaker::Time.date
    phone FFaker::PhoneNumber.short_phone_number
    quote FFaker::Lorem.sentence
    ambition FFaker::Lorem.sentence
    address FFaker::AddressNL
    occupation FFaker::Job.title
    country FFaker::Address.city
    gender 0
    is_public false
    user
  end
end
