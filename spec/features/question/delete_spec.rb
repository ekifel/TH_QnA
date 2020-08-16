require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete question
  As authenticated user
  I'd like to be able to delete my question
} do

  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:wrong_user) { create(:user) }

    background { sign_in(user) }

    context 'can delete his question'do
      given!(:question) { create(:question, user: user) }

      scenario 'question deletes successfully' do
        visit question_path(question)
        within('.question') do
          click_on 'Delete'
        end

        expect(page).to have_content 'Your question deleted successfully'
        expect(page).to_not have_content question.title
      end
    end

    context 'can not delete not his own question' do
      given!(:question) { create(:question, user: wrong_user) }

      scenario 'delete question button does not exist' do
        visit question_path(question)

        within('.question') do
          expect(page).to_not have_link 'Delete'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    given!(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }

    scenario 'can not delete any questions' do
      visit question_path(question)

      within('.question') do
        expect(page).to_not have_link 'Delete'
      end
    end
  end
end
