class SuscribeMailer < ApplicationMailer
  def notice(subscription)
    @question = subscription.question
    mail to: @question.user.email, subject: 'You recieve answer'
  end
end
