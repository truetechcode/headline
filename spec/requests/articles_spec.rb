# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Articles" do
  let(:articles) do
    [
      {
        source: { id: "associated-press", name: "Associated Press" },
        author: "Susie Blann",
        title: "Russian private army head claims control of Bakhmut but Ukraine says fighting continues - The Associated
       Press",
        description: "KYIV, Ukraine (AP) — The head of the Russian private army Wagner claimed Saturday that his forces
      have taken control of the city of Bakhmut after the longest and most grinding battle of the Russia-Ukraine war,
      but Ukrainian defense officials denied it.",
        url: "https://apnews.com/article/bakhmut-russia-ukraine-wagner-prigozhin-da2fc05b818b3dcc39decd40b17d2d8b",
        url_to_image: "https://storage.googleapis.com/afs-prod/media/8dd9fdbbef9d4727a480b275e08fe599/2879.webp",
        publish_at: "2023-05-20T15:37:42Z",
        content: "KYIV, Ukraine (AP) The head of the Russian private army Wagner claimed Saturday that his forces have
       taken control of the city of Bakhmut after the longest and most grinding battle of the Russia-Ukra…"
      }
    ]
  end
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

    instance.call

    create(:user, name: "user", email: "user@example.com", password: "password", password_confirmation: "password")
    post sessions_path, params: { session: { email: "user@example.com", password: "password" } }
  end

  describe "GET /index" do
    context "with no saved article" do
      before do
        follow_redirect!
      end

      it "has http status of success" do
        expect(response).to have_http_status(:success)
      end

      it "renders Headlines" do
        expect(response.body).to include("Headlines")
      end

      it "does not increase Article count" do
        expect(Article.count).to eq(0)
      end

      it "returns a message: No Headlines" do
        expect(response.body).to include("No Headlines")
      end
    end

    context "with at least one saved article" do
      let(:article) do
        create(:article, source: articles[0][:source][:name], author: articles[0][:author],
                         title: articles[0][:title], description: articles[0][:description],
                         url: articles[0][:url], url_to_image: articles[0][:url_to_image],
                         publish_at: articles[0][:publish_at], content: articles[0][:content],
                         user: User.last)
      end

      before do
        follow_redirect!
      end

      it "renders article source" do
        expect(response.body).to include(article["source"])
      end

      it "renders article Title" do
        expect(response.body).to include(article["title"])
      end

      it "renders article url" do
        expect(response.body).to include(article["url"])
      end
    end
  end

  describe "POST /articles" do
    context "with valid attributes" do
      before do
        create(:user)
        article_attributes = attributes_for(:article)
        post articles_path, params: { article: article_attributes }
      end

      it "creates a new article" do
        Article.last
        expect(Article.count).to eq(1)
      end

      it "have http status of redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it "redirects to the correct path" do
        expect(response).to redirect_to(root_path)
      end

      it "returns a successful response" do
        follow_redirect!
        expect(response).to have_http_status(:success)
      end

      it "renders 'Headline successfully saved'" do
        follow_redirect!
        expect(response.body).to include("Headline successfully saved")
      end
    end

    context "with invalid attributes" do
      it "does not create article" do
        article = build(:article, user: nil)

        expect(article.save).to be_falsey
      end

      it "returns an error for no user" do
        article = build(:article, user: nil)
        article.save

        expect(article.errors[:user]).to include("must exist")
      end
    end
  end

  describe "DELETE /articles" do
    let!(:article) { create(:article, user: User.last) }

    it "deletes the article" do
      expect do
        delete article_path(article)
      end.to change(Article, :count).by(-1)
    end
  end
end
