require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:questions) { create_list(:question, 3, created_at: 1.day.ago) }
  let(:users) { create_list(:user, 2) }
  
  it 'sends daily digest' do
    users.each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
    DailyDigestJob.perform_now
  end
end
