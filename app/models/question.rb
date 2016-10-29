class Question < ApplicationRecord
  include Votable
  include Commentable
  
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user
  has_one :best_answer, -> { where(best: true) }, class_name: Answer

  scope :for_digest, -> { where("DATE(created_at) = ?", Date.today-1) }
  
  validates :title, :body, :user_id, presence: true
  validates :title, length: { maximum: 100 }
  accepts_nested_attributes_for :attachments, allow_destroy: true
end
