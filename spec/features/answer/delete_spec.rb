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

      scenario 'answer deletes successfully' do
        visit question_path(question)
        click_on 'Delete answer'

        expect(page).to have_content 'Your answer deleted successfully'
        expect(page).to_not have_content answer.body
      end
    end

    context 'delete answer button does not exist' do
      given!(:question) { create(:question, user: user) }
      given!(:answer) { create(:answer, question: question, user: wrong_user) }

      scenario 'answer not deletes' do
        visit question_path(question)

        expect(page).to_not have_link 'Delete answer'
      end
    end
  end

  describe 'Unauthenticated user' do
    given!(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }

    scenario 'can not delete any answers' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end
end
