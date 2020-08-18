require 'rails_helper'

feature 'User can create answer', %q{
  In order to make answer to question
  As an authenticated user
  I'd like to be able to make answer to question
} do

  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to post correct answer to question' do
      fill_in 'Body', with: 'Answer body'
      click_on 'Post Your Answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Your answer posted successfully'
      expect(page).to have_content 'Answer body'
    end

    scenario 'tries to post empty answer', js: true do
      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to post answer with attached file' do
      fill_in 'Body', with: 'Answer body'
      attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Post Your Answer'

      within '.answers' do
        expect(page).to have_content('Answer body')
        expect(page).to have_link('rails_helper.rb')
      end
    end

    scenario 'tries to post answer with several attached file' do
      fill_in 'Body', with: 'Answer body'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Post Your Answer'

      within '.answers' do
        expect(page).to have_content('Answer body')
        expect(page).to have_link('rails_helper.rb')
        expect(page).to have_link('spec_helper.rb')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to give an answer' do
      visit question_path(question)
      click_on 'Post Your Answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
