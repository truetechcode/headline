class ArticlesController < ApplicationController
def index
@articles = Article.all
@live_articles = []
end

def new; end

def create
  @article = Article.new(articles_params)
  @article.user = User.last
  if @article.save
    flash[:success] = "Article successfully saved"
    redirect_to root_path
  else
    flash[:error] = @article.errors.full_messages[0]
    render 'new'
  end
end

protected

def articles_params
  params.require(:article).permit(:source, :author, :title, :description, :content, :url, :url_to_image, :publish_at, :user)
end
end
