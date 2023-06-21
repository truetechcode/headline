# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :signed_in_user

  def index
    @articles = current_user.articles
    @country_code = (params[:country] || current_user.country_code).downcase
    news_service = NewsApi.new(@country_code)
    @live_articles = news_service.call || []

    respond_to do |format|
      format.html { render }
      format.json { render json: { saved_headlines: @articles, headlines: @live_articles }, status: :ok }
    end
  end

  def new; end

  def create
    @article = build_article
    if save_article
      handle_successful("saved", :created)
    else
      handle_failed
    end
  end

  def destroy
    @article = Article.find_by(id: params[:id])
    if !@article.nil? && @article.destroy

      handle_successful("deleted", nil)

    elsif @article.nil?
      handle_not_found
    else
      handle_failed
    end
  end

  private

  def build_article
    current_user.articles.build(articles_params).tap do |article|
      article.user = current_user
    end
  end

  def save_article
    @article.save
  end

  def handle_successful(item, status)
    Rails.logger.info("Headline successfully #{item}")

    respond_to do |format|
      format.html do
        flash[:success] = "Headline successfully #{item}"
        redirect_to root_path
      end
      format.json { render json: { message: "Headline successfully #{item}", headline: @article }, status: }
    end
  end

  def handle_failed
    log_error @article.errors.full_messages.join
    respond_to do |format|
      format.html do
        flash.now[:error] = message
        render "new"
      end
      format.json { render json: { error: @article.errors.full_messages.join }, status: :unprocessable_entity }
    end
  end

  def handle_not_found
    log_error "Headline not found"
    respond_to do |format|
      format.html do
        flash[:error] = message
        redirect_to articles_url
      end
      format.json { render json: { error: "Headline not found" }, status: :unprocessable_entity }
    end
  end

  def log_error(message)
    Rails.logger.error(message)
  end

  protected

  def articles_params
    params.require(:article).permit(:source, :author, :title, :description, :content, :url, :url_to_image, :publish_at,
                                    :user)
  end
end
