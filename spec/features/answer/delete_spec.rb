require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to delete answer
  As authenticated user
  I'd like to be able to delete answer
} do

  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:wrong_user) { create(:user) }

    background { sign_in(user) }

    context 'can delete his answer' do
      given!(:question) { create(:question, user: user) }
      given!(:answer) { create(:answer, question: question, user: user) }

      scenario 'answer deletes successfully', js: true do
        visit question_path(question)
        within("#answer-id-#{answer.id}") do
          click_on 'Delete'
        end

        expect(page).to have_content 'Your answer deleted successfully'
        expect(page).to_not have_content answer.body
      end
    end

    context 'delete answer button does not exist' do
      given!(:question) { create(:question, user: user) }
      given!(:answer) { create(:answer, question: question, user: wrong_user) }

      scenario 'user can not see button' do
        visit question_path(question)

        within("#answer-id-#{answer.id}") do
          expect(page).to_not have_link 'Delete'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    given!(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }

    scenario 'can not see delete button' do
      visit question_path(question)

      within("#answer-id-#{answer.id}") do
        expect(page).to_not have_link 'Delete'
      end
    end
  end
end
