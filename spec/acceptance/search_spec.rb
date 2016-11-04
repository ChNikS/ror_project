require_relative 'acceptance_thinking_sphinx_helper'

feature 'Users can search content', %q{
  In order to be able to find interested topics
  as an non-registered user
  i want to be able to search
  } do
  let! (:user) { create(:user) }
  let!(:question) { create(:question, body: 'test', user: user) }
  let!(:answer) { create :answer, content: 'answer', usert: user }
  let!(:comment) { create :comment, content: 'test comment', commentable_id: question.id, commentable_type: 'Question', user: user}  

  before do
    visit root_path    
    fill_in 'q', with: 'longtitle'    
  end

  scenario 'search by all', sphinx: true do
    ThinkingSphinx::Test.run do
      select('Everywhere', from: 'a')
      click_on 'search_button'

      expect(current_path).to eq search_path

      
      expect(page).to have_content question.body
      expect(page).to have_content comment.body
      expect(page).to_not have_content answer.body
    end
  end

  scenario 'search by question', sphinx: true do
    ThinkingSphinx::Test.run do
      select('Question', from: 'a')
      click_on 'search_button'

      expect(current_path).to eq search_path

      
      expect(page).to have_content question.body
      expect(page).to_not have_content comment.body
      expect(page).to_not have_content answer.body
    end
  end

  scenario 'search by answer', sphinx: true do
    ThinkingSphinx::Test.run do
      select('Answer', from: 'a')
      click_on 'search_button'

      expect(current_path).to eq search_path

      
      expect(page).to_not have_content question.body
      expect(page).to_not have_content comment.body
      expect(page).to have_content answer.body
    end
  end

end
