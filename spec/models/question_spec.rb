require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_presence_of :user_id}
    it { should validate_length_of(:title).is_at_most(100) }
  end
  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments) }
  it { should accept_nested_attributes_for :attachments }

   describe '#create_subscription_for_author' do
    let(:user) { create(:user) }
    let(:question) { build(:question, user: user) }
    
    it 'create subscription for author' do
      expect(user).to receive(:subscribe_to).with(question).and_call_original
      question.save
    end  
  end

  describe 'for_digest scope' do
    let!(:two_day_question) { create :question, created_at: 2.days.ago }
    let!(:yesterday_question) { create :question, created_at: 1.days.ago }
    let!(:today_question) { create :question, created_at: Time.now }      

    it 'must contain question from yesterday' do
      expect(Question.for_digest.first).to eq yesterday_question
    end
  end

end
