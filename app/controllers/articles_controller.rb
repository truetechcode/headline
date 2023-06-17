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
  @article = current_user.articles.build(articles_params)
  @article.user = current_user
  if @article.save
    Rails.logger.info("Headline successfully saved")
    flash[:success] = "Headline successfully saved"

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: { message: 'Headline successfully saved', headline: @article }, status: :created }
    end
  else
    Rails.logger.error(@article.errors.full_messages.join)
    flash[:error] = @article.errors.full_messages.join

    respond_to do |format|
      format.html { render 'new' }
      format.json { render json: { error: @article.errors.full_messages.join }, status: :unprocessable_entity  }
    end
  end
end

def destroy
  @article = Article.find_by(id: params[:id])
  if !@article.nil? and @article.destroy
    Rails.logger.info("Headline was successfully deleted.")
    flash[:success] = 'Headline was successfully deleted.'

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { render json: { message: 'Headline successfully deleted', headline: nil } }
    end
  else
    if @article.nil?
      Rails.logger.error("Headline not found")
      flash[:error] = "Headline not found"

      respond_to do |format|
        format.html { redirect_to articles_url }
        format.json { render json: { error: "Headline not found" }, status: :unprocessable_entity  }
      end
    else
      Rails.logger.error(@article.errors.full_messages.join)
      flash[:error] = @article.errors.full_messages.join

      respond_to do |format|
        format.html { redirect_to articles_url }
        format.json { render json: { error: @article.errors.full_messages.join }, status: :unprocessable_entity  }
      end
    end
  end
end

protected

def articles_params
  params.require(:article).permit(:source, :author, :title, :description, :content, :url, :url_to_image, :publish_at, :user)
end
end
