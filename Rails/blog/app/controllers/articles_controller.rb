class ArticlesController < ApplicationController
    # Basic http authenticaction   
    # http_basic_authenticate_with name: "n", password: "p", except: [:index, :show]

    # Using devise with author model
    before_action :authenticate_author!, only: [:new,:create, :edit, :update, :destroy]

    def edit
        @article = Article.find(params[:id]) 
    end

    def update
        @article = Article.find(params[:id])    
        if @article.update(article_params)
          redirect_to @article
        else
          render 'edit'
        end
    end

    def index # Intended for list available articles
        @articles = Article.all  # All articles 
    end

    def new
        @article = Article.new
    end

    def create
        # @article =  Article.new(params[:title], params[:text]) # This is a way
        @article =  Article.new(article_params) #More security
        if @article.save
            redirect_to @article
        else
            #render plain: "Not valid data" # Primitive render
            render 'new'
        end
    end

    def show
        @article = Article.find(params[:id]) # Find article by id
    end

    def search
        @articles = Article.find(params[:search])
    end

    def destroy
        @article = Article.find(params[:id])
        @article.destroy
        redirect_to articles_path
    end

    private
    def article_params
        params.require(:article).permit(:title, :text)
    end

end
