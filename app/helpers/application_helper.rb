module ApplicationHelper
  def placeholder_image_news(size: '300x150')
    Faker::Placeholdit.image(size: size, format: 'jpeg', background_color: :random, text: 'Headlines')
  end
end
