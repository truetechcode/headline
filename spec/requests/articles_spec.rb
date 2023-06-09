require 'rails_helper'

RSpec.describe "Articles", type: :request do
  describe "GET /index" do
    before(:each) do
      create(:user, name: 'user', email: 'user@example.com', password: 'password', password_confirmation: 'password')
      post sessions_path, params: { session: {email: 'user@example.com', password: 'password'} }
    end

    it 'renders Headlines' do
      @live_articles = []
      get articles_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Headlines')
    end

    context "with at least one saved article" do
      before(:each) do
        @article = create(:article, user: User.last)
      end

      it 'renders article source' do
        get articles_path

        expect(response.body).to include(@article['source'])
      end
      it 'renders article Title' do
        get articles_path

        expect(response.body).to include(@article['title'])
      end

      it 'renders article url' do
        get articles_path

        expect(response.body).to include(@article['url'])
      end
      it 'renders article url_to_image' do
        get articles_path

        expect(response.body).to include(URI.parse(@article['url_to_image']).host)
      end
      it 'renders article publish_at' do
        get articles_path

        expect(response.body).to include(@article['publish_at'])
      end
    end

    context "with no saved article" do
      it 'returns a message: No Headlines' do
        get articles_path

        expect(Article.count).to eq(0)
        expect(response.body).to include('No Headlines')
      end
    end
  end

  describe 'POST /articles' do
    before(:each) do
      create(:user, name: 'user', email: 'user@example.com', password: 'password', password_confirmation: 'password')
      post sessions_path, params: { session: {email: 'user@example.com', password: 'password'} }
    end

    context "with valid attributes" do
      before(:each) do
        create(:user)
        article_attributes = FactoryBot.attributes_for(:article)
        post articles_path, params: { article: article_attributes }
      end

      it "creates a new article" do
        new_record = Article.last
        expect(Article.count).to eq(1)
      end

      it "redirects to the correct path" do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end

      it "returns a successful response with the expected content" do
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response.body).to include('Headline successfully saved')
      end
    end

    context "with invalid attributes" do
      before(:each) do
        create(:user, name: 'user', email: 'user@example.com', password: 'password', password_confirmation: 'password')
        post sessions_path, params: { session: {email: 'user@example.com', password: 'password'} }
      end

      it "returns an error for no user" do
        article = build(:article, user: nil)
        article.save

        expect(article).not_to be_valid
        expect(article.errors[:user]).to include("must exist")
      end
    end
  end

  describe 'DELETE /articles' do
    let!(:article) { FactoryBot.create(:article) }
    before(:each) do
      create(:user, name: 'user', email: 'user@example.com', password: 'password', password_confirmation: 'password')
      post sessions_path, params: { session: {email: 'user@example.com', password: 'password'} }
      @article = create(:article, user: User.last)
    end

    it 'deletes the article' do
      expect {
        delete article_path(@article)
      }.to change(Article, :count).by(-1)

    end
  end
end
