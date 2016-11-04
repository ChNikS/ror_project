class Question < ApplicationRecord
  include Votable
  include Commentable
  after_create :subscribe_author
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user
  has_one :best_answer, -> { where(best: true) }, class_name: Answer

  scope :for_digest, -> {  where(created_at: 1.day.ago.all_day) }
  
  validates :title, :body, :user_id, presence: true
  validates :title, length: { maximum: 100 }
  accepts_nested_attributes_for :attachments, allow_destroy: true

  def subscribe_author
    user.subscribe_to(self)
  end
end
