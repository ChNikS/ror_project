require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.search_for' do
    let!(:params) { { a: 'Question', q: 'question' } }
    
    it 'search' do
      expect(ThinkingSphinx).to receive(:search).with('question', classes: [Question]).and_call_original
      Search.search_for(params)
    end
  end
end