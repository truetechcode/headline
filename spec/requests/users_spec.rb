require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe 'GET /users/new' do
    it 'renders the new template' do
      get new_user_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('User Registration Form')
      expect(response.body).to include('Full name')
      expect(response.body).to include('Email')
      expect(response.body).to include('Password')
      expect(response.body).to include('Register')
    end

  end

  describe 'POST /users' do
    context "with valid attributes" do
      it "creates a new user" do
        user_attributes = FactoryBot.attributes_for(:user)
        post users_path, params: { user: user_attributes }

        new_record = User.last
        expect(User.all.count).to eq(1)
      end

      it "redirects to the correct path" do
        user_attributes = FactoryBot.attributes_for(:user)
        post users_path, params: { user: user_attributes }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end

      it "returns a successful response with the expected content" do
        user_attributes = FactoryBot.attributes_for(:user)
        post users_path, params: { user: user_attributes }
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response.body).to include('User successfully registered')
      end
    end

    context "with invalid attributes" do
      it "returns an error for blank name" do
        user_attributes = FactoryBot.attributes_for(:user)
        post users_path, params: { user: user_attributes.merge(name: '') }

        expect(User.all.count).to eq(0)
        expect(response.body).to include("Name can&#39;t be blank")
      end

      it "returns an error for blank email" do
        user_attributes = FactoryBot.attributes_for(:user, email: '')
        post users_path, params: { user: user_attributes }

        expect(User.all.count).to eq(0)
        expect(response.body).to include("Email can&#39;t be blank")
      end

      it "returns an error for password shorter than 6 characters" do
        user_attributes = FactoryBot.attributes_for(:user, password: '')
        post users_path, params: { user: user_attributes }

        expect(User.all.count).to eq(0)
        expect(response.body).to include("Password is too short")
      end
    end

  end
end
