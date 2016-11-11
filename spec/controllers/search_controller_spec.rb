require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    it 'search' do
      expect(ThinkingSphinx).to receive(:search).and_call_original
      get :index, params: { a: 'Question', q: 'search' }
    end
  end
end
