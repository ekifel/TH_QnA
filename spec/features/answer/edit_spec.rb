require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:wrong_answer) { create(:answer, question: question, user: create(:user)) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background { sign_in user }
    background { visit question_path(question) }

    scenario 'edits his answer' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      within '.answer_errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    context "other user's answer" do
      scenario "tries to edit other user's answer" do
        within "#answer-id-#{wrong_answer.id}" do
          expect(page).to_not have_link 'Edit'
        end
      end
    end
  end
end
