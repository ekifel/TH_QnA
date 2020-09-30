require 'rails_helper'

feature 'User can see answer changes in realtime', %q{
   In order to get information immediately
   I'd like to ba able to get actual information
 } do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:url) { 'https://gist.github.com/ekifel/4a058cb88bf37fba63c4d4513b98de77' }

  context 'when new answer created', js: true do
    scenario "this answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new-answer' do
          fill_in 'Your answer', with: 'Answer body'

          click_on 'Post Your Answer'
        end

        within '.answers' do
          expect(page).to have_content('Answer body')
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content('Answer body')
        end
      end
    end
  end

  context "post comment to answer", js: true do
    given!(:answer) { create(:answer, question: question) }

    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
            fill_in :comment_body, with: 'Comment body'

            click_on 'Post Comment'

            expect(page).to have_content('Comment body')
          end
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
            expect(page).to have_content('Comment body')
          end
        end
      end
    end
  end
end
