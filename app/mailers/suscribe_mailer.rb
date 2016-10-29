class SuscribeMailer < ApplicationMailer
  def notice(subscription)
    @question = subscription.question
    mail to: subscription.user.email, subject: 'You recieve answer'
  end
end
