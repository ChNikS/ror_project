shared_examples_for 'voted' do |parameter|
  sign_in_user

  let!(:user) { create :user }
  let!(:votable) { create(parameter.underscore.to_sym, user: user) }

  describe 'POST #like' do
    context 'non author' do
      it 'vote count changed by 1' do
        expect { post :like, id: votable, format: :json }.to change(votable.votes, :count).by(1)
      end

      it 'vote value changed by 1' do
        post :like, id: votable, format: :json
        expect(votable.votes.last.value).to eq 1
      end
    end

    context 'try to vote twice' do
      before { post :like, id: votable, format: :json }

      it 'does not change total value' do
        expect { post :like, id: votable, format: :json }.to_not change(Vote, :count)
      end

      it 'total value still 1' do
        expect(votable.total).to eq 1
      end

      it 'show error message' do
        post :like, id: votable, format: :json

        expect(JSON.parse(response.body)['error']).to eq 'You cannot vote'
      end
    end

    context 'author' do
      before { votable.update_attributes(user: @user) }

      it 'vote count not changed' do
        expect { post :like, id: votable, format: :json }.to_not change(votable.votes, :count)
      end

      it 'total value does not changed' do
        expect { post :like, id: votable, format: :json }.to_not change(Vote, :count)
      end

      it 'show error message' do
        post :like, id: votable, format: :json

        expect(JSON.parse(response.body)['error']).to eq 'You cannot vote'
      end
    end
  end

  describe 'POST #dislike' do
    context 'non author' do
      it 'vote count changed by 1' do
        expect { post :dislike, id: votable, format: :json }.to change(votable.votes, :count).by(1)
      end

      it 'vote value changed by 1' do
        post :dislike, id: votable, format: :json
        expect(votable.votes.last.value).to eq(-1)
      end
    end

    context 'try to vote twice' do
      before { post :dislike, id: votable, format: :json }

      it 'does not change total value' do
        expect { post :dislike, id: votable, format: :json }.to_not change(Vote, :count)
      end

      it 'total value still -1' do
        expect(votable.total).to eq(-1)
      end

      it 'show error message' do
        post :dislike, id: votable, format: :json

        expect(JSON.parse(response.body)['error']).to eq 'You cannot vote'
      end
    end

    context 'author' do
      before { votable.update_attributes(user: @user) }

      it 'vote count not changed' do
        expect { post :dislike, id: votable, format: :json }.to_not change(votable.votes, :count)
      end

      it 'total value does not changed' do
        expect { post :dislike, id: votable, format: :json }.to_not change(Vote, :count)
      end

      it 'show error message' do
        post :dislike, id: votable, format: :json

        expect(JSON.parse(response.body)['error']).to eq 'You cannot vote'
      end
    end
  end

  describe 'PATCH #change_vote' do
    context 'non author' do
      it 'change like to dislike' do
        post :like, id: votable, format: :json
        patch :change_vote, id: votable, format: :json
        votable.reload

        expect(votable.votes.last.value).to eq(-1)
      end

      it 'change dislike to like' do
        post :dislike, id: votable, format: :json
        patch :change_vote, id: votable, format: :json
        votable.reload

        expect(votable.votes.last.value).to eq 1
      end
    end

    context 'author' do
      before do
        post :like, id: votable, format: :json

        votable.update_attributes(user: @user)
      end

      it 'try to change vote' do
        patch :change_vote, id: votable, format: :json
        votable.reload

        expect(votable.votes.last.value).to eq 1
      end

      it 'change dislike to like' do
        patch :change_vote, id: votable, format: :json

        expect(JSON.parse(response.body)['error']).to eq 'You cannot vote'
      end
    end
  end

  describe 'DELETE #cancel_vote' do
    context 'non author' do
      before { post :dislike, id: votable, format: :json }

      it 'votable value changed' do
        delete :cancel_vote, id: votable, format: :json

        expect(votable.total).to eq 0
      end

      it 'entries in database changed' do
        expect { delete :cancel_vote, id: votable, format: :json }.to change(Vote, :count).by(-1)
      end
    end

    context 'author' do
      before do
        post :dislike, id: votable, format: :json

        votable.update_attributes(user: @user)
      end

      it 'entries in database changed' do
        expect { delete :cancel_vote, id: votable, format: :json }.to_not change(Vote, :count)
      end

      it 'show error message' do
        post :cancel_vote, id: votable, format: :json

        expect(JSON.parse(response.body)['error']).to eq 'You cannot vote'
      end
    end
  end
end