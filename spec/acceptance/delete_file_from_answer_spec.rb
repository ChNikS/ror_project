require_relative 'acceptance_helper'

feature 'Delete files from answer', %q{
  In order to rid of old files
  as an answer's author
  i'd like to be able to delete files
} do

  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:attachment) { create(:attachment, attachmentable: answer) }

  scenario 'User deletes file from answer', js: true do
    sign_in(user)
    visit question_path(question)
    
    expect(page).to have_link(attachment.file.identifier) 
    
    within '.answer_files' do
      click_on 'Delete file'
    end  
    
    expect(page).to have_no_link(attachment.file.identifier)    
  end

  scenario 'Other user tries to delete file' do
    sign_in(other_user)
    visit question_path(question)
    within '.answer_files' do
      expect(page).to have_no_link('Delete file')
    end

  end
end