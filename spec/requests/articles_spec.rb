require 'rails_helper'

RSpec.describe "Articles", type: :request do
  describe "GET /index" do
    it 'renders all articles' do
      get articles_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Headlines')
    end
  end

  describe 'POST /articles' do
    context "with valid attributes" do
      it "creates a new article" do
        create(:user)
        article_attributes = FactoryBot.attributes_for(:article)
        post articles_path, params: { article: article_attributes }

        new_record = Article.last
        expect(Article.all.count).to eq(1)
      end

      it "redirects to the correct path" do
        create(:user)
        article_attributes = FactoryBot.attributes_for(:article)
        post articles_path, params: { article: article_attributes }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end

      it "returns a successful response with the expected content" do
        create(:user)
        article_attributes = FactoryBot.attributes_for(:article)
        post articles_path, params: { article: article_attributes }

        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response.body).to include('Article successfully saved')
      end
    end

    context "with invalid attributes" do
      it "returns an error for no user" do
        article_attributes = FactoryBot.attributes_for(:article)
        post articles_path, params: { article: article_attributes }

        new_record = Article.last
        expect(Article.all.count).to eq(0)
        expect(response.body).to include("User must exist")
      end
    end
  end
end
