shared_examples_for "votable" do
  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let(:user_3) { create(:user) }
  let(:votable) { create(described_class.to_s.underscore.to_sym) }
  
  describe '#vote' do
    it ':like' do
      expect { votable.vote(user, 1) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.last.value).to eq 1
    end
    
    it ':dislike' do
      expect { votable.vote(user, -1) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.last.value).to eq(-1)
    end
  end
  
  it '#change_vote' do
    votable.vote(user, 1)
    votable.change_vote_value(user)
    
    expect(votable.votes.last.value).to eq(-1)
  end
  
  it '#cancel_evaluate' do
    votable.vote(user, 1)
    
    expect { votable.cancel_votable(user) }.to change(Vote, :count).by(-1)
  end

  it '#total' do
    votable.vote(user, 1)
    
    votable.vote(user_2, -1)
    votable.vote(user_3, 1)
    
    expect(votable.total).to eq(1)
  end
end