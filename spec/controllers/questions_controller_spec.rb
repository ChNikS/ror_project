require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }
    
    it 'assigns a new Question to a @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before {get :edit, id: question}
    
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    
    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'rederects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'do not save new invalid question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 'renew new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end

    context 'Private_pub' do
      it 'recieves publish_to' do
        expect(PrivatePub).to receive(:publish_to)

        post :create, question: attributes_for(:question)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'valid attributes' do
      it 'assigns the required question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it 'chnges question attributes' do
        patch :update, id: question, question:{title: 'new title', body: 'new body'}
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirect to updated question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end
    end
    
    context 'invalid attributes' do
      it 'does not change question attributes' do
        patch :update, id: question, question:{title: 'new title', body: nil}	
        question.reload
        expect(question.title).to eq 'Question title'
          expect(question.body).to eq 'Question text'
      end

      it 're-render edit template' do
        patch :update, id: question, question: attributes_for(:question)
        get :edit, id: question
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'Author deletes his question' do
      before { question.update_attribute(:user, @user) }
      
      it 'delete question' do
        question
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)  		
      end

      it 'redirect to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path()
      end
    end

    context 'Other user tries to delete' do
      let(:other_user) { create(:user) }
      let!(:other_question) { create(:question, user: other_user) }
      
      it 'delete other question' do
        expect { delete :destroy, params: { id: other_question } }.to_not change(Question, :count)
      end

      it 'redirect to show view' do
        delete :destroy, params: { id: other_question }
        expect(response).to redirect_to other_question
      end
    end
  end

  describe 'POST #subscribe' do
    sign_in_user
    before { question }

    it 'saves the new subscribe in the database' do
      expect { post :subscribe, params: { id: question, format: :js } }.to change(question.subscriptions, :count).by(1)
    end
    
    it 'subscribe belongs to user' do      
      expect { post :subscribe, params: { id: question, format: :js } }.to change(@user.subscriptions, :count).by(1)
    end
    
    it 'render view' do
      post :subscribe, params: { id: question, format: :js }
      
      expect(response).to render_template :subscribe
    end
  end
  
  describe 'DELETE #unsubscribe' do
    sign_in_user
    let!(:subscription) { create(:subscription, question: question, user: @user) }

    it 'saves the new subscribe in the database' do
      expect { delete :unsubscribe, params: { id: question, format: :js } }.to change(Subscription, :count).by(-1)
    end
    
    it 'render view' do
      delete :unsubscribe, params: { id: question, format: :js }
      
      expect(response).to render_template :unsubscribe
    end
  end

  it_behaves_like 'voted', 'question'
end