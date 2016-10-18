module Voted
  extend ActiveSupport::Concern
  
  included do
    before_action :load_votable, only: [:like, :dislike, :change_vote, :cancel_vote]
    respond_to :json, only: [:like, :dislike, :change_vote, :cancel_vote]
  end

  def like
    authorize! :like, @votable
    respond_with(@votable.vote(current_user, 1), template: 'votes/vote.json.jbuilder')
  end

  def dislike
    authorize! :dislike, @votable
    respond_with(@votable.vote(current_user, -1), template: 'votes/vote.json.jbuilder')
  end

  def change_vote
    authorize! :change_vote, @votable
    respond_with(@votable.change_vote_value(current_user), template: 'votes/vote.json.jbuilder')
  end

  def cancel_vote
    authorize! :cancel_vote, @votable
    respond_with(@votable.cancel_votable(current_user), template: 'votes/vote.json.jbuilder')
  end

  private

   def load_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
end