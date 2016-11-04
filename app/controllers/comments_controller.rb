class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]
  before_action :load_comment, except: [:create]
  after_action :publish
  
  authorize_resource
  
  respond_to :js, :json

  def create
    @method = "create"
    respond_with(@comment = @commentable.comments.create(comment_params))
  end

  def update
    @method = "update"
    @comment.update(comment_params)
    respond_with(@comment)
  end

  def destroy
    @method = "delete"
    respond_with(@comment.destroy)
  end
  
  private

    def comment_params
      params.require(:comment).permit(:body)
    end

    def load_commentable
    @commentable = commentable_type.classify.constantize.find(params["#{commentable_type}_id"])
  end

  def commentable_type
    params[:commentable_type]
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def send_url(commentable)
    commentable.class == Question ? commentable.id : commentable.question_id
  end

  def publish
    PrivatePub.publish_to("/questions/#{ send_url(@comment.commentable) }/comments", comment: @comment.to_builder, method: @method) if @comment.valid? 
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end
