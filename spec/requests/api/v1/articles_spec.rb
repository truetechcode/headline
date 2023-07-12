# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Articles" do
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
          totalResults: articles.size,
          articles:
        }.to_json,
        headers: { "Content-Type": "application/json" }
      )

    create(:user, name: "user", email: "user@example.com", password: "password",
                  password_confirmation: "password")
    post "/api/v1/sessions", params: { session: { email: "user@example.com", password: "password" } }, as: :json
  end

  describe "GET /api/v1/articles" do
    context "with no saved article" do
      before do
        get "/api/v1/articles"
      end

      it "has http status of success" do
        expect(response).to have_http_status(:success)
      end

      it "returns a JSON response" do
        expect(response.content_type).to include("application/json")
      end

      it "returns a JSON response with an empty array for saved_headlines" do
        expect(response.parsed_body["saved_headlines"]).to be_empty
      end

      it "returns a JSON response with headlines" do
        expect(response.parsed_body["headlines"]).not_to be_empty
      end
    end

    context "with at least one saved article" do
      before do
        create(:article, source: articles[0][:source], author: articles[0][:author],
                         title: articles[0][:title], description: articles[0][:description],
                         url: articles[0][:url], url_to_image: articles[0][:url_to_image],
                         publish_at: articles[0][:publish_at], content: articles[0][:content],
                         user: User.last)

        get "/api/v1/articles"
      end

      it "has http status of success" do
        expect(response).to have_http_status(:success)
      end

      it "returns a JSON response" do
        expect(response.content_type).to include("application/json")
      end

      it "returns a JSON response with saved_headlines" do
        expect(response.parsed_body["saved_headlines"]).not_to be_empty
      end

      it "returns a JSON response with live headlines" do
        expect(response.parsed_body["headlines"]).not_to be_empty
      end

      it "renders article title" do
        expect(response.parsed_body["headlines"][0]["title"]).to include(Article.last.title)
      end
    end
  end

  describe "POST /api/v1/articles" do
    context "when user is authenticated" do
      before do
        create(:user)
        article_attributes = attributes_for(:article)
        post "/api/v1/articles", params: { article: article_attributes }, as: :json
      end

      it "creates a new article" do
        expect(Article.count).to eq(1)
      end

      it "returns a success status code" do
        expect(response).to have_http_status(:success)
      end

      it "returns a JSON response" do
        expect(response.content_type).to include("application/json")
      end

      it "returns a JSON response with the saved headline" do
        expect(response.parsed_body["headline"]).not_to be_empty
      end
    end

    context "when user is not authenticated" do
      let(:article) { build(:article, user: nil) }

      before do
        delete "/api/v1/sessions/#{User.last.id}"
      end

      it "does not create an article" do
        expect do
          post "/api/v1/articles", params: { article: attributes_for(:article) }, as: :json
        end.not_to change(Article, :count)
      end
    end
  end

  describe "DELETE /articles" do
    let!(:article) { create(:article) }

    it "deletes the article" do
      expect do
        delete "/api/v1/articles/#{article.id}"
      end.to change(Article, :count).by(-1)
    end
  end
end
