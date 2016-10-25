require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user

  let(:another_user) { create :user }
  let(:question) { create :question, user: @user }
  let(:answer) { create :answer, user: @user, question: question }
  let!(:comment) { create :comment, user: @user }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save new comment for question' do
        expect { post :create, comment: attributes_for(:comment), commentable_type: 'question', question_id: question.id, format: :js }
          .to change(question.comments, :count).by(1)
      end

      it 'save new comment for answer' do
        expect { post :create, comment: attributes_for(:comment), commentable_type: 'answer', answer_id: answer.id, format: :js }
          .to change(answer.comments, :count).by(1)
      end

      it 'new comment belongs to user' do
        post :create, comment: attributes_for(:comment), commentable_type: 'question', question_id: question.id, format: :js

        expect(assigns(:comment).user).to eq @user
      end

      it 'recieves publish_to Private_pub' do
        expect(PrivatePub).to receive(:publish_to)
        post :create, params: { commentable_type: 'question', comment: attributes_for(:comment), question_id: question.id, format: :json }
      end
    end

    context 'with valid attributes' do
      it 'save new comment for question' do
        expect { post :create, comment: attributes_for(:invalid_comment), commentable_type: 'question', question_id: question.id, format: :js }
          .to_not change(Comment, :count)
      end

      it 'do not receive publish_to Private_pub' do
        expect(PrivatePub).to_not receive(:publish_to)
        post :create, params: { commentable_type: 'question', comment: attributes_for(:comment), question_id: question.id, format: :json }
      end
    end
  end

  describe 'PATCH #update' do
    context 'owner' do
      it 'assigns the requested comment to @comment' do
        patch :update, id: comment, comment: attributes_for(:comment), format: :js

        expect(assigns(:comment)).to eq comment
      end

      it 'update comment content' do
        patch :update, id: comment, comment: { body: 'new content' }, format: :js
        comment.reload

        expect(comment.body).to eq 'new content'
      end

      it 'render update template' do
        patch :update, id: comment, comment: { body: 'new content' }, format: :js

        expect(response).to render_template :update
      end

      it 'recieves publish_to Private_pub' do
        expect(PrivatePub).to receive(:publish_to)
        patch :update, params: { id: comment, comment: attributes_for(:comment), format: :js }
      end
    end

    context 'non owner' do
      before { comment.update_attribute(:user, another_user) }

      it 'comment not updated' do
        patch :update, id: comment, comment: { body: 'new content' }, format: :js
        comment.reload

        expect(comment.body).to eq 'test comment'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'owner' do
      it 'delete comment' do
        expect { delete :destroy, id: comment, format: :js }.to change(Comment, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, id: comment, format: :js

        expect(response).to render_template :destroy
      end

      it 'recieves publish_to Private_pub' do
        expect(PrivatePub).to receive(:publish_to)
        delete :destroy, params: { id: comment, format: :json }
      end
    end

    context 'non owner' do
      before { comment.update_attribute(:user, another_user) }

      it 'cant delete comment' do
        expect { delete :destroy, id: comment, format: :js }.to_not change(Comment, :count)
      end
    end
  end
end
