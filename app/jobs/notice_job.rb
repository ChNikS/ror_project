class NoticeJob < ApplicationJob
  queue_as :default

  def perform(question)
    Subscription.for_question(question.id).find_each do |subscription|
      SuscribeMailer.notice(subscription).deliver_later
    end
  end
end
