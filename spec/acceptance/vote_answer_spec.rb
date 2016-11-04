require_relative 'acceptance_helper'

feature 'Add vote to answwer',  %q{
  In order to find answer for created question
  as an user
  i want to be able to view list of questions
}  do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create :answer, question: question, user: other_user }

  describe 'Author tries to vote' do
    sign_in(other_user)
    visit question_path(question)
    within('.answers') do
       expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
        expect(page).to_not have_link 'change vote'
        expect(page).to_not have_link 'cancel vote'
    end
  end

  describe 'User tries to vote' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'like answer', js: true do
      within('.answers') do
        click_on 'like'

        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
        expect(page).to have_link 'change vote'
        expect(page).to have_link 'cancel vote'

        within('.votable-total') { expect(page).to have_content('1') }
      end
    end

    scenario 'dislike answer', js: true do
      within('.answers') do
        click_on 'dislike'

        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
        expect(page).to have_link 'change vote'
        expect(page).to have_link 'cancel vote'

        within('.votable-total') { expect(page).to have_content('-1') }
      end
    end

    scenario 'change vote for answer', js: true do
      within('.answers') do
        click_on 'like'
        click_on 'change vote'

        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
        expect(page).to have_link 'change vote'
        expect(page).to have_link 'cancel vote'

        within('.votable-total') { expect(page).to have_content('-1') }
      end
    end

    scenario 'cancel vote for answer', js: true do
      within('.answers') do
        click_on 'like'
        click_on 'cancel vote'

        expect(page).to have_link 'like'
        expect(page).to have_link 'dislike'
        expect(page).to_not have_link 'change vote'
        expect(page).to_not have_link 'cancel vote'

        within('.votable-total') { expect(page).to have_content('0') }
      end
    end
  end 
end