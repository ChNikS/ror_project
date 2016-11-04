module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def total
    votes.sum(:value)
  end
  
  def vote(user, value)
    votes.create(user: user, value: value)    
  end
  
  def change_vote_value(user)
    votes.where(user: user).update_all("value = (-1) * value")
    votes.reload
  end  
  
  def cancel_votable(user)
    votes.where(user: user).delete_all
  end
end