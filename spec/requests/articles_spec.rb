# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Articles" do
  before do
    @articles = [
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
      },
      {
        source: { id: nil, name: "POLITICO.eu" },
        author: "Ashleigh Furlong",
        title: "Russia warns West sending F-16s to Ukraine 'carries enormous risks': TASS - POLITICO Europe",
        description: "Kyiv has pushed its allies to supply modern combat aircraft for Ukraine’s defense against the
        Russian invasion.",
        url: "https://www.politico.eu/article/russia-alexander-grushko-warns-west-f16-jets-ukraine-carries-enormous-risks-tass/",
        url_to_image: "https://www.politico.eu/cdn-cgi/image/width=1200,height=630,fit=crop,quality=80,onerror=redirect/wp-content/uploads/2023/05/20/GettyImages-1488520640-scaled.jpg",
        publish_at: "2023-05-20T15:22:00Z",
        content: "The Wests effort to potentially send modern fighter jets to Ukraine carries enormous risks, Russias
        Deputy Foreign Minister Alexander Grushko warned on Saturday, according to Russian state news agenc…"
      }
    ]

    allow_any_instance_of(NewsApi).to receive(:call).and_return(@articles)

    create(:user, name: "user", email: "user@example.com", password: "password", password_confirmation: "password")
    post sessions_path, params: { session: { email: "user@example.com", password: "password" } }
  end

  describe "GET /index" do
    before do
      follow_redirect!
    end

    it "renders Headlines" do
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Headlines")
    end

    context "with at least one saved article" do
      before do
        @article = create(:article, source: @articles[0][:source][:name], author: @articles[0][:author],
                                    title: @articles[0][:title], description: @articles[0][:description],
                                    url: @articles[0][:url], url_to_image: @articles[0][:url_to_image],
                                    publish_at: @articles[0][:publish_at], content: @articles[0][:content],
                                    user: User.last)
      end

      it "renders article source" do
        expect(response.body).to include(@article["source"])
      end

      it "renders article Title" do
        expect(response.body).to include(@article["title"])
      end

      it "renders article url" do
        expect(response.body).to include(@article["url"])
      end

      it "renders article url_to_image" do
        expect(response.body).to include(URI.parse(@article["url_to_image"]).host)
      end

      it "renders article publish_at" do
        expect(response.body).to include(@article["publish_at"])
      end
    end

    context "with no saved article" do
      it "returns a message: No Headlines" do
        expect(Article.count).to eq(0)
        expect(response.body).to include("No Headlines")
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

      it "redirects to the correct path" do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end

      it "returns a successful response" do
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Headline successfully saved")
      end
    end

    context "with invalid attributes" do
      it "returns an error for no user" do
        article = build(:article, user: nil)
        article.save

        expect(article).not_to be_valid
        expect(article.errors[:user]).to include("must exist")
      end
    end
  end

  describe "DELETE /articles" do
    let!(:article) { create(:article) }

    before do
      @article = create(:article, user: User.last)
    end

    it "deletes the article" do
      expect do
        delete article_path(@article)
      end.to change(Article, :count).by(-1)
    end
  end
end
