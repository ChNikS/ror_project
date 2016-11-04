require "rails_helper"

RSpec.describe SuscribeMailerMailer, type: :mailer do
  describe 'notice' do
    let(:user) { create :user }
    let(:question) { create :question, user: user }
    let(:answer) { create :answer, question: question. user: user }
    let(:mail) { SuscribeMailer.notice(answer) }

     it 'renders the headers' do
      expect(mail.subject).to eq('You recieve answer')
      expect(mail.to).to eq([question.user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders message body' do
      expect(mail.body.encoded).to match('A new answer was created for question you are interested in. You can find it by passing through a link below')
      expect(mail.body.encoded).to match(question.title)
    end

  end
end
