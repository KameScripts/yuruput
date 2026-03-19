class PostsController < ApplicationController

  def index
    @posts = current_user.posts.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, success: t('defaults.flash_message.created', item: Post.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Post.model_name.human)
      render :new_post_path, status: :unprocessable_entity
    end
  end
    
  def show
    @post = current_user.posts.find(params[:id])
  end
  
  def edit
    @post = current_user.posts.find(params[:id])
  end
  
  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), success: t('defaults.flash_message.updated', item: Post.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_updated', item: Post.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
    redirect_to posts_path, status: :see_other, success: t('defaults.flash_message.deleted', item: Post.model_name.human)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

end
