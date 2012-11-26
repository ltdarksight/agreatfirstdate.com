class BlogController < ApplicationController
  before_filter :find_post_by_alias, only: [:show, :edit]
  def index
    @posts = Post.recent.paginate(:page => params[:page])
  end
  
  def show

  end
  
private
  def find_post_by_alias
    @post = Post.find_by_alias(params[:alias])
  end
end
