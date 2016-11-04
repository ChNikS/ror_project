class Subscription < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :question_id, :user_id, presence: true

  scope :for_question, -> (id) { where(question_id: id) }
end
