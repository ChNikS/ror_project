class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    questions = Question.for_digest
    User.find_each do |user|
      DailyMailer.digest(user, questions).deliver_later
    end
  end
end
