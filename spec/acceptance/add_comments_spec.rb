require_relative 'acceptance_helper'

feature 'Add comments', '
  In order to make it clearer
  as an authenticated user
  i want to be able make comments
' do
  let!(:user) { create :user }
  let!(:other_user) { create :user }
  let!(:question) { create :question }
  let!(:other_comment) { create :comment, user: other_user}

  describe 'Non-authenticated user' do
    before do
      visit question_path(question)
    end

    scenario 'can not add comment', js: true do
      expect(page).to_not have_content('Add comment')
    end
  end

  describe 'Authenticated user' do
    
    context 'comment author' do
      before do
        sign_in(user)
        visit question_path(question)
        within '.question_comments' do
          fill_in 'comment_body', with: 'comment1'
          click_on 'Add comment'
        end
      end

      scenario 'add comment', js: true do
        within '.question_comments' do
          expect(page).to have_content('comment1')
        end
      end

      scenario 'edit comment', js: true do
        within '.edit_comment' do
          fill_in 'comment_body', with: 'comment_edited'
          click_on 'Update comment'
        end
        expect(page).to have_content('comment_edited')
      end 

      scenario 'delete comment', js: true do
        within '.question_comments' do  
          click_on 'Delete comment'        
          expect(page).to_not have_content('comment1')
        end
      end
    end

    context 'other user' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'tries to delete other user comment' do
        expect(page).to_not have_content('Delete comment')
      end

      scenario 'tries to update other user comment' do
        expect(page).to_not have_content('Update comment')
      end
    end
  end
end