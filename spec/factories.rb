FactoryBot.define do

  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    country_code {'us'}
  end

  factory :article do
    source { Faker::Name.name }
    author { Faker::Name.name }
    title { Faker::Hipster.sentence }
    description { Faker::Hipster.paragraph_by_chars(characters: 56, supplemental: false) }
    content { Faker::Hipster.paragraph_by_chars(characters: 156, supplemental: false) }
    url { Faker::Internet.url(host: 'example.com', path: '/foobar.html') }
    url_to_image { Faker::Avatar.image } # Faker::Placeholdit.image
    publish_at { Faker::Movies::Avatar.date }

    user
  end
end
