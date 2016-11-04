class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy
  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  default_scope { order(best: :desc, created_at: :asc) }

  def best!
    Answer.transaction  do      
    self.question.answers.where(best: true).update_all(best: false)
    self.best = true
    self.save!
    end
  end 

  def to_builder
    jbuilder = Jbuilder.new do |answer|
      answer.id id
      answer.user user_id
      answer.body body
      answer.question question_id
      answer.attachments attachments
    end
    jbuilder.target!
  end 
end
