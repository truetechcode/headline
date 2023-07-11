# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions" do
  describe "GET /new" do
    it "returns http success" do
      get "/sessions/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /sessions" do
    let(:user) do
      { name: "user", email: "user@example.com", password: "password", password_confirmation: "password",
        country_code: "us" }
    end

    let(:articles) { build_list(:populated_article, 1) }

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
    end

    context "with valid credentials" do
      before do
        User.create! user
        post "/api/v1/sessions", params: { session: { email: "user@example.com", password: "password" } }
      end

      it "have a http status response of success" do
        expect(response).to have_http_status(:ok)
      end

      it "returns a JSON response" do
        expect(response.content_type).to include("application/json")
      end

      it "returns a JSON response with success message" do
        expect(response.body).to include("Logged in successfully")
      end

      it "returns the correct user attributes" do
        expect(response.body).to include(user[:email].to_json)
      end
    end

    context "with invalid credentials" do
      before do
        User.create! user
        post "/api/v1/sessions", params: { session: { email: "user@example.com", password: "" } }
      end

      it "have a http status response of success" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns a JSON response" do
        expect(response.content_type).to include("application/json")
      end

      it "returns a JSON response with error message" do
        expect(response.body).to include("Invalid email or password.")
      end
    end
  end

  describe "DELETE /sessions" do
    let(:user) do
      create(:user, name: "user", email: "user@example.com", password: "password", password_confirmation: "password",
                    country_code: "us")
    end

    before do
      post "/api/v1/sessions", params: { session: { email: "user@example.com", password: "password" } }
      delete "/api/v1/sessions/#{user.id}"
    end

    it "have a http status response of success" do
      expect(response).to have_http_status(:ok)
    end

    it "returns a JSON response" do
      expect(response.content_type).to include("application/json")
    end

    it "returns a JSON response with success message" do
      expect(response.body).to include("Logged out successfully")
    end
  end
end
