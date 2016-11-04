require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let!(:question) { create(:question, user: @user) }
  
  let!(:answer) { create(:answer, question: question, user: @user) }

  describe 'GET #new' do
  	before { get :new, params: { question_id: question } }
  	it 'creates a new Answer' do
  	  expect(assigns(:answer)).to be_a_new(Answer)
  	end

  	it 'renders new view' do
      expect(response).to render_template :new
    end
  end
  
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
      expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
    end

      it 'answer has author' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer).user).to eq subject.current_user
      end

      it 'rederects to show question with answers' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
      
      it 'recieves publish_to' do
        expect(PrivatePub).to receive(:publish_to)
        
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
      end
    end

    context 'with invalid attributes' do
      it 'does not save an answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js } }.to_not change(Answer, :count)
      end

      it 're-renders new' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end

      it 'do not recieves publish_to' do
        expect(PrivatePub).to receive(:publish_to)
        
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
      end
    end    
  end

  describe 'PATCH #update' do

    context 'Author tries to update his question' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

       it 'render update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'Private_pub' do
      it 'recieves publish_to' do
        expect(PrivatePub).to receive(:publish_to)
        
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
      end
    end
  end

  describe 'PATCH #best' do
    let(:answer_author) { create(:user) }
    let!(:another_answer) { create(:answer, question: question, user: answer_author, best: false) }
    context 'Question author choose best answer' do

      it 'assigns the requested answer to @answer' do
        patch :best, params: { id: answer, format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'set the best answer' do
        patch :best, params: { id: answer, format: :js }
        answer.reload
        expect(answer.best).to eq true
      end

      it 'choose another best answer' do
        patch :best, params: { id: another_answer, format: :js }
        answer.reload
        another_answer.reload

        expect(answer.best).to eq false
        expect(another_answer.best).to eq true
      end
    end

    context 'Not question author choose best answer' do
      before do 
        question.update_attribute(:user, answer_author)       
      end
      it 'another user tries to choose best answer' do
        patch :best, params: { id: answer, format: :js }
        answer.reload
        
        expect(answer.best).to eq false
      end
    end    
  end

  describe 'DELETE #destroy' do
    context 'author deletes his answer' do
      before { answer }

      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(Answer, :count).by(-1)
      end

      it 'render destroy' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'not author delete' do
      let(:other_user) { create(:user) }
      let!(:other_answer) { create(:answer, question: question, user: other_user) }
      it 'delete other answer' do
        expect { delete :destroy, params: { id: other_answer, format: :js } }.to_not change(Answer, :count)
      end
    end

    context 'Private_pub' do
      it 'recieves publish_to' do
        expect(PrivatePub).to receive(:publish_to)
        
        delete :destroy, params: { id: answer, format: :js }
      end
    end
  end

  it_behaves_like 'voted', 'answer'
end

