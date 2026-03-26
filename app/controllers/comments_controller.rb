class CommentsController < ApplicationController
  def create
    @post = current_user.posts.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    if @comment.save
      redirect_to post_path(@post), success: t('defaults.flash_message.created', item: Comment.model_name.human)
    else
      @comments = @post.comments.order(created_at: :desc)
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Comment.model_name.human)
      render 'posts/show', status: :unprocessable_entity
    end
  end

def destroy
    # 1. まずコメントIDを元に、データベースから該当のコメントを探し出す
    @comment = Comment.find(params[:id])
    
    # 2. セキュリティ対策：他人の投稿についたコメントを勝手に消せないようにする
    if @comment.post.user == current_user
      @comment.destroy!
    end
    
    # 3. 削除が終わったら、元の投稿詳細画面（@comment.post）にリダイレクトする
    # 💡 Turbo仕様のため status: :see_other を忘れずに！
    redirect_to post_path(@comment.post), status: :see_other, success: t('defaults.flash_message.deleted', item: Comment.model_name.human)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
