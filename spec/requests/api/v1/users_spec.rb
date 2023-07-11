# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Users" do
  describe "POST /api/v1/users" do
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
        post "/api/v1/users", params: { user: user_attributes }
      end

      it "creates a new user" do
        expect(User.count).to eq(1)
      end

      it "have a http status response of success" do
        expect(response).to have_http_status(:created)
      end

      it "returns a JSON response" do
        expect(response.content_type).to include("application/json")
      end

      it "returns the correct user attributes" do
        expect(response.body).to include(articles[0][:user].to_json)
      end
    end

    context "with invalid attributes" do
      it "does not increment User count" do
        user_attributes = attributes_for(:user)
        post "/api/v1/users", params: { user: user_attributes.merge(name: "") }

        expect(User.count).to eq(0)
      end

      it "returns an error for blank name" do
        user_attributes = attributes_for(:user)
        post "/api/v1/users", params: { user: user_attributes.merge(name: "") }

        expect(response.body).to include({ errors: "Name can't be blank" }.to_json)
      end

      it "returns an error for blank email" do
        user_attributes = attributes_for(:user, email: "")
        post "/api/v1/users", params: { user: user_attributes }

        expect(response.body).to include({ errors: "Email can't be blank" }.to_json)
      end

      it "returns an error for password shorter than 6 characters" do
        user_attributes = attributes_for(:user, password: "")
        post "/api/v1/users", params: { user: user_attributes }

        expect(response.body).to include({
          errors: "Password can't be blankPassword is too short (minimum is 5 characters)"
        }.to_json)
      end

      it "returns an error for blank country code" do
        user_attributes = attributes_for(:user)
        post "/api/v1/users", params: { user: user_attributes.merge(country_code: "") }

        expect(response.body).to include({ errors: "Country code can't be blank" }.to_json)
      end
    end
  end
end
