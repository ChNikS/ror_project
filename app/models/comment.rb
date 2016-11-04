class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, optional: true
  
  validates :user_id, :body, presence: true

  default_scope { order(created_at: :asc) }

  def to_builder
    jbuilder = Jbuilder.new do |comment|
      comment.id id
      comment.user user_id
      comment.body body
      comment.commentable_type commentable_type.downcase
      comment.commentable_id commentable_id
    end
    jbuilder.target!
  end
end
