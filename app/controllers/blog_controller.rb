class BlogController < ApplicationController
  before_filter :find_post_by_alias, only: [:show, :edit]
  before_filter :authenticate_admin!, only: [:edit, :new]
  def index
    @posts = Post.recent
  end
  
  def show

  end
  
  def new
    @post = Post.new
  end
  
  def edit
    
  end
  
private
  def find_post_by_alias
    @post = Post.find_by_alias(params[:alias])
  end
end
