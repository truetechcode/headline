# frozen_string_literal: true

module Api
  module V1
    # This is a ArticlesController responsible for managing article-related actions.
    class ArticlesController < ApplicationController
      before_action :signed_in_user

      def index
        articles = current_user.articles
        country_code = fetch_country_code
        news_service = NewsApi.new(country_code)
        live_articles = news_service.call

        respond_to do |format|
          format.json { render json: { saved_headlines: articles, headlines: live_articles }, status: :ok }
        end
      end

      def create
        article = build_article
        return unless article.save

        handle_successful("saved", :created, article)
      end

      def destroy
        article = Article.find_by(id: params[:id])

        if article&.destroy
          handle_successful("deleted", nil, article)
        elsif article.nil?
          handle_not_found "Headline not found"
        end
      end

      private

      def fetch_country_code
        (params[:country] || current_user.country_code).downcase
      end

      def build_article
        current_user.articles.build(articles_params).tap do |article|
          article.user = current_user
        end
      end

      def handle_successful(item, status, article)
        Rails.logger.info("Headline successfully #{item}")

        respond_to do |format|
          format.json do
            render json: { message: "Headline successfully #{item}", headline: article }, status:
          end
        end
      end

      def handle_not_found(message)
        Rails.logger.error message
        respond_to { |format| format.json { render json: { error: message }, status: :unprocessable_entity } }
      end

      protected

      def articles_params
        params.require(:article).permit(:source, :author, :title, :description, :content, :url, :url_to_image, :publish_at,
                                        :user)
      end
    end
  end
end
