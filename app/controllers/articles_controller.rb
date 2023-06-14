class ArticlesController < ApplicationController
before_action :signed_in_user

def index
  @articles = current_user.articles
  @country_code = (params[:country] || current_user.country_code).downcase
  news_service = NewsApi.new(@country_code)
  @live_articles = news_service.call || []
end

def new; end

def create
  @article = current_user.articles.build(articles_params)
  @article.user = User.last
  if @article.save
    Rails.logger.info("Headline successfully saved")
    flash[:success] = "Headline successfully saved"
    redirect_to root_path
  else
    Rails.logger.error(@article.errors.full_messages[0])
    flash[:error] = @article.errors.full_messages[0]
    render 'new'
  end
end

def destroy
  @article = Article.find(params[:id])
  if @article.destroy
    Rails.logger.info("Headline was successfully deleted.")
    flash[:success] = 'Headline was successfully deleted.'
    redirect_to articles_url
  else
    Rails.logger.error(@article.errors.full_messages[0])
    flash[:error] = @article.errors.full_messages[0]
    redirect_to articles_url
  end
end

protected

def articles_params
  params.require(:article).permit(:source, :author, :title, :description, :content, :url, :url_to_image, :publish_at, :user)
end
end
