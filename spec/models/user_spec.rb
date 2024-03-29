# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  describe "registration" do
    it "creates a new user with valid attributes" do
      user = build(:user)

      expect(user.save).to be_truthy
    end

    it "does not create a new user with invalid name attribute" do
      user = build(:user, name: nil)

      expect(user.save).to be_falsey
    end

    it "does not create a new user with invalid email attribute" do
      user = build(:user, email: nil)

      expect(user.save).to be_falsey
    end

    it "does not create a new user without unique email attribute" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")

      expect(user.save).to be_falsey
    end

    it "does not create a new user with mismatch password attribute" do
      user = build(:user, password: nil)

      expect(user.save).to be_falsey
    end
  end

  describe "remember token" do
    let(:user) { build(:user) }

    it "saves a new user" do
      expect(user.save).to be_truthy
    end

    it "creates a new remember token when a user is saved" do
      user.save
      expect(user.remember_token).not_to be_nil
    end
  end
end
