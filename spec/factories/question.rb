FactoryGirl.define do
  factory :question do
  	title "title1"
  	body "Question text"
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
