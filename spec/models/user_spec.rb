require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'registration' do
    it 'creates a new user with valid attributes' do
      user = build(:user)

      expect(user.save).to be_truthy
    end

    it 'does not create a new user with invalid name attribute' do
      user = build(:user, name: nil)

      expect(user.save).to be_falsey
    end

    it 'does not create a new user with invalid email attribute' do
      user = build(:user, email: nil)

      expect(user.save).to be_falsey
    end

    it 'does not create a new user with mismatch password attribute' do
      user = build(:user, password: nil)

      expect(user.save).to be_falsey
    end
  end

  describe "remember token" do
    it 'creates a new remember token when a user is saved' do
      user = build(:user)
      expect(user.save).to be_truthy

      expect(user.remember_token).to_not be_nil
    end
  end
end
