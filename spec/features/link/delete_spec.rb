require 'rails_helper'

feature 'User can create delete link from question/answer', %q{
  In order to correct mistakes
  As an author of answer/question
  I'd like to be able to delete attached links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }
  given!(:question_link) { create(:link, linkable: question) }
  given!(:answer_link) { create(:link, linkable: answer) }

  describe 'Authenticate user', js: true do
    before {  sign_in(user) }
    before {  visit question_path(question) }

    context 'Delete question link ' do
      scenario "question's owner try delete link" do
        within '.question' do
          click_on 'Edit'

          within '#new-links' do
            click_on 'Delete link'
          end

          click_on 'Save'
        end
        expect(page).to_not have_link question_link.name
      end
    end

    context 'Delete answer link' do
      scenario 'answer owner try delete link' do
        within '.answers' do
          click_on 'Edit'

          within '#new-links' do
            click_on 'Delete link'
          end

          click_on 'Save'
        end
        expect(page).to_not have_link answer_link.name
      end
    end
  end
end
