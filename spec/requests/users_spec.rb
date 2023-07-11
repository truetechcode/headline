# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users" do
  describe "GET /users/new" do
    it "returns a success response" do
      get new_user_path

      expect(response).to have_http_status(:success)
    end

    it "renders the new template with 'User Registration Form'" do
      get new_user_path

      expect(response.body).to include("User Registration Form")
    end

    it "renders the new template with 'Full name'" do
      get new_user_path

      expect(response.body).to include("Full name")
    end

    it "renders the new template with 'Register'" do
      get new_user_path

      expect(response.body).to include("Register")
    end
  end

  describe "POST /users" do
    context "with valid attributes" do
      let(:articles) { build_list(:populated_article, 1) }
      let(:instance) { NewsApi.new("us") }

      before do
        stub_request(:get, "https://newsapi.org/v2/top-headlines?apiKey=#{ENV.fetch('NEWSAPI_KEY', nil)}&country=us")
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent" => "Ruby"
            }
          )
          .to_return(
            status: 200,
            body: {
              status: "ok",
              totalResults: 0,
              articles:
            }.to_json,
            headers: { "Content-Type": "application/json" }
          )

        allow(instance).to receive(:call).and_return(articles)

        user_attributes = attributes_for(:user)
        post users_path, params: { user: user_attributes }
      end

      it "creates a new user" do
        User.last
        expect(User.count).to eq(1)
      end

      it "have http status redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it "redirects to the correct path" do
        expect(response).to redirect_to(root_path)
      end

      it "returns a successful response" do
        follow_redirect!
        expect(response.body).to include("User successfully registered")
      end
    end

    context "with invalid attributes" do
      it "does not increment User count" do
        user_attributes = attributes_for(:user)
        post users_path, params: { user: user_attributes.merge(name: "") }

        expect(User.count).to eq(0)
      end

      it "returns an error for blank name" do
        user_attributes = attributes_for(:user)
        post users_path, params: { user: user_attributes.merge(name: "") }

        expect(response.body).to include("Name can&#39;t be blank")
      end

      it "returns an error for blank email" do
        user_attributes = attributes_for(:user, email: "")
        post users_path, params: { user: user_attributes }

        expect(response.body).to include("Email can&#39;t be blank")
      end

      it "returns an error for password shorter than 6 characters" do
        user_attributes = attributes_for(:user, password: "")
        post users_path, params: { user: user_attributes }

        expect(response.body).to include("Password is too short")
      end

      it "returns an error for blank country code" do
        user_attributes = attributes_for(:user)
        post users_path, params: { user: user_attributes.merge(country_code: "") }

        expect(response.body).to include("Country code can&#39;t be blank")
      end
    end
  end
end
