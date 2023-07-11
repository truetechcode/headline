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

      allow(instance).to receive(:call).and_return(
        status: 200,
        body: {
          status: "ok",
          totalResults: 0,
          articles:
        }.to_json,
        headers: { "Content-Type": "application/json" }
      )

      response = instance.call
      JSON.parse(response[:body])["articles"]
    end

    context "with valid credentials" do
      before do
        User.create! user
        post sessions_path, params: { session: { email: "user@example.com", password: "password" } }
      end

      it "redirects to the root path" do
        expect(response).to redirect_to(root_path)
      end

      it "sets a success notice" do
        expect(flash[:success]).to eq("Logged in successfully.")
      end

      it "renders 'Logged in successfully.'" do
        follow_redirect!

        expect(response.body).to include("Logged in successfully.")
      end
    end

    context "with invalid credentials" do
      before do
        User.create! user
        post sessions_path, params: { session: { email: "user@example.com", password: "" } }
      end

      it "sets an alert flash message" do
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
      post sessions_path, params: { session: { email: "user@example.com", password: "password" } }
      delete session_path(user)
    end

    it "redirects to root path" do
      expect(response).to redirect_to(root_path)
    end

    it "sets the flash notice message" do
      expect(flash[:success]).to eq("Logged out successfully.")
    end
  end
end
