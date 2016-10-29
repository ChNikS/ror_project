require 'rails_helper'

RSpec.describe NoticeJob, type: :job do
  let(:question) { create(:question) }
  let!(:new_answer) { create(:answer, question: question) }
  let!(:subscription) { create(:subscription, question: question) }
  
  it 'Sends notification emails to subscribers ' do
    new_answer.question.subscriptions.each do |subscription|
      expect(SuscribeMailer).to receive(:notice).with(subscription).and_call_original
    end
    NoticeJob.perform_now(new_answer)
  end
end
