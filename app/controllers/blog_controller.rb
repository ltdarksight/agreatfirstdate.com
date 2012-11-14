class BlogController < ApplicationController
  before_filter :find_post_by_alias, only: [:show, :edit]
  before_filter :authenticate_admin!, only: [:edit]
  def index
    @posts = Post.all
  end
  
  def show

  end
  
  def edit
    
  end
  
private
  def find_post_by_alias
    @post = Post.find_by_alias(params[:alias])
  end
end
