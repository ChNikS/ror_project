require_relative 'acceptance_helper'

feature 'Subscribe to question', %q{
  In order to receive notice about changes own question 
  as an user
  i want to be able to subscribe own question
} do
  let(:user) { create(:user) }
  let(:other) { create(:user) }
  let(:question) { create(:question, user: user) }
    
  describe 'Author of question' do
    before do
      sign_in(user)
      visit question_path(question)
      
    end
    
    scenario 'sees unsubscribe link', js: true do 
      expect(page).to have_link 'Unsubscribe'
    end
    
    scenario 'tries to unsubscribe to the question', js: true do 
      click_on 'Unsubscribe'
      
      expect(page).to have_content('You have unsubcribed for this question')
    end
  end
  
  describe 'Authenticated user' do
    before do
      sign_in(other)
      visit question_path(question)
    end
    
    scenario 'sees subscribe link', js: true do 
      expect(page).to have_link 'Subscribe'
    end
    
    scenario 'tries to subscribe to the question', js: true do 
      click_on 'Subscribe'
      
     expect(page).to have_content('You have subcribed for this question')
    end
  end
  
  describe 'Non-authenticated user' do
    scenario 'tries to subscribe to the question' do
      visit question_path(question)
      
      expect(page).to have_no_link 'Subscribe'
      expect(page).to have_no_link 'Unsubscribe'
    end
  end
end