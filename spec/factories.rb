# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    country_code { "us" }
  end

  factory :article do
    source { Faker::Name.name }
    author { Faker::Name.name }
    title { Faker::Hipster.sentence }
    description { Faker::Hipster.paragraph_by_chars(characters: 56, supplemental: false) }
    content { Faker::Hipster.paragraph_by_chars(characters: 156, supplemental: false) }
    url { Faker::Internet.url(host: "example.com", path: "/foobar.html") }
    url_to_image { Faker::Avatar.image } # Faker::Placeholdit.image
    publish_at { Faker::Movies::Avatar.date }

    user

    factory :populated_article do
      source do
        "Associated Press"
      end
      author { "Susie Blann" }
      title do
        "Russian private army head claims control of Bakhmut but Ukraine says fighting continues -
        The Associated Press"
      end
      description do
        "KYIV, Ukraine (AP) — The head of the Russian private army Wagner claimed Saturday that his forces
        have taken control of the city of Bakhmut after the longest and most grinding battle of the Russia-Ukraine war,
        but Ukrainian defense officials denied it."
      end
      url { "https://apnews.com/article/bakhmut-russia-ukraine-wagner-prigozhin-da2fc05b818b3dcc39decd40b17d2d8b" }
      url_to_image { "https://storage.googleapis.com/afs-prod/media/8dd9fdbbef9d4727a480b275e08fe599/2879.webp" }
      publish_at { "2023-05-20T15:37:42Z" }
      content do
        "KYIV, Ukraine (AP) The head of the Russian private army Wagner claimed Saturday that his forces have
         taken control of the city of Bakhmut after the longest and most grinding battle of the Russia-Ukraine war"
      end
    end
  end
end
