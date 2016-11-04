class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, optional: true
  belongs_to :user

  validates :user_id, presence: true
  validates :value, inclusion: { in: [-1, 1] }
end
