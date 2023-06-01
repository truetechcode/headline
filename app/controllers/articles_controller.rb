class ArticlesController < ApplicationController

def index
  @articles = Article.all

  news_service = NewsApi.new('us')
  @live_articles = news_service.call || []
end

def new; end

def create
  @article = Article.new(articles_params)
  @article.user = User.last
  if @article.save
    flash[:success] = "Headline successfully saved"
    redirect_to root_path
  else
    flash[:error] = @article.errors.full_messages[0]
    render 'new'
  end
end

def destroy
  @article = Article.find(params[:id])
  if @article.destroy
    flash[:success] = 'Headline was successfully deleted.'
    redirect_to articles_url
  else
    flash[:error] = @article.errors.full_messages[0]
    redirect_to articles_url
  end
end

protected

def articles_params
  params.require(:article).permit(:source, :author, :title, :description, :content, :url, :url_to_image, :publish_at, :user)
end
end
