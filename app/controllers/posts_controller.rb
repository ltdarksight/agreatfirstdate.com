class PostsController < ApplicationController
  before_filter :find_post, only: [:edit, :update, :destroy]
  before_filter :authenticate_admin!
  
  def new
    @post = Post.new
  end
  
  def edit
    
  end
  
  def update
    if @post.update_attributes(params[:post])
      redirect_to blog_post_path(@post.alias)
    else
      render :edit
    end
  end
  
  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect_to blog_post_path(@post.alias)
    else
      render :new
    end
  end
  
  def destroy
    @post.destroy
    redirect_to blog_path
  end
  
private
  def find_post
    @post = Post.find(params[:id])
  end
end
