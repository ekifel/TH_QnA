require 'rails_helper'

feature 'User can create comments for answer', %q{
   In order to give feedback about answer
   As a authenticated user
   I'd like to ba able to create comment for answer
 } do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }
    background { visit question_path(question) }

    context 'can create comment' do
      scenario 'with correct params' do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
            fill_in :comment_body, with: 'Comment body'

            click_on 'Post Comment'

            expect(page).to have_content('Comment body')
          end
        end
      end
    end

    context 'can not create comment' do
      scenario 'with empty body' do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
            fill_in :comment_body, with: ''

            click_on 'Post Comment'

            within '.comment-errors' do
              expect(page).to have_content("Body can't be blank")
            end
          end
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    given!(:question) { create(:question) }

    background { visit question_path(question) }

    scenario 'can not create comment' do
      within "#question-#{question.id}" do
        expect(page).to_not have_link 'Post Comment'
      end
    end
  end
end
