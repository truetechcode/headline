require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'validation' do
    it 'creates a new article with a valid attributes' do
      article = build(:article)

      expect(article.save).to be_truthy
    end

    it 'does not create a new article without a valid user attribute' do
      user = build(:article, user: nil)

      expect(user.save).to be_falsey
    end
  end
end
