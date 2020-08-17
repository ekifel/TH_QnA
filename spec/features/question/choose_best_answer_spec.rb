require 'rails_helper'

feature "Question's owner can choose best answer", %q{
  In order to choose best answer
  As a authenticated user and author of the question
  I'd like to be able to select best answer
} do

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background { sign_in(user) }

    context 'is question owner' do
      context 'with one answer' do
        given!(:question) { create(:question, user: user) }
        given!(:answer) { create(:answer, question: question) }

        scenario 'can select best answer' do
          visit question_path(question)

          within("#answer-id-#{answer.id}") { click_on 'Best' }
          within('.best-answer') do
            expect(page).to have_content 'This answer is best'
            expect(page).to have_content answer.body
          end
        end
      end

      context 'with more answers' do
        given!(:question) { create(:question, user: user) }
        given!(:answer) { create(:answer, question: question) }

        context 'when best answer already exist' do
          given(:best_answer) { create(:answer, question: question, best: true) }

          scenario 'can select another answer as best' do
            visit question_path(question)

            within("#answer-id-#{answer.id}") { click_on 'Best' }
            within '.best-answer' do
              expect(page).to have_content answer.body
              expect(page).to_not have_content best_answer.body
            end
          end
        end
      end
    end

    context 'is not question owner' do
      given!(:question) { create(:question) }
      given!(:answer) { create_list(:answer, 3, question: question) }

      scenario "so button 'Best' does not exist" do
        visit question_path(question)

        within('.answers') { expect(page).to_not have_link 'Best' }
      end
    end
  end

  describe 'Unauthenticated user' do
    given!(:question) { create(:question) }
    given!(:answer) { create_list(:answer, 3, question: question) }

    scenario "button 'Best' does not exist" do
      visit question_path(question)

      within('.answers') { expect(page).to_not have_link 'Best' }
    end

  end
end
