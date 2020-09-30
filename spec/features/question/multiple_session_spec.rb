require 'rails_helper'

feature 'User can see questions changes in realtime', %q{
   In order to get information immediately
   I'd like to ba able to get actual information
 } do

  given(:user) { create(:user) }

  context 'when new question create', js: true do
    scenario "this question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'Title', with: 'Title question'
        fill_in 'Body', with: 'Body question'
        click_on 'Save'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content('Title question')
        expect(page).to have_content('Body question')
      end

      Capybara.using_session('guest') do
        within '.questions' do
          expect(page).to have_link 'Title question'
          expect(page).to have_content 'Body question'
        end
      end
    end
  end

  context 'add comment for question', js: true do
    given(:question) { create(:question) }

    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within "#question-#{question.id}" do
          fill_in :comment_body, with: 'Comment body'

          click_on 'Post Comment'

          expect(page).to have_content('Comment body')
        end
      end

      Capybara.using_session('guest') do
        within "#question-#{question.id}" do
          expect(page).to have_content('Comment body')
        end
      end
    end
  end
end
