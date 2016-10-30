require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe 'digest' do  
    let(:user) { create :user }
    let(:questions) { create_list(:question, 2, user: user) }  
    let(:mail) { DailyMailer.digest(user, questions) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Questions')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'render questions' do
      questions.each do |question|
        expect(mail.body.encoded).to match(question.title)
      end
    end 
  end

end
