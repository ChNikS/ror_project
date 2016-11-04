require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id}
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }

  describe 'check_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, user: user, best: false) }
    let!(:other_answer) { create(:answer, question: question, user: user, best: true) } 

    it 'check best answer' do
      answer.best!
      answer.reload
      other_answer.reload
      expect(answer.best).to eq true
      expect(other_answer.best).to eq false
    end
  end
end
