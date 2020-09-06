require 'rails_helper'

feature 'User can create answer', %q{
  In order to make answer to question
  As an authenticated user
  I'd like to be able to make answer to question
} do

  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/ekifel/4a058cb88bf37fba63c4d4513b98de77' }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to post correct answer to question' do
      fill_in 'Your answer', with: 'Answer body'
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
      fill_in 'Your answer', with: 'Answer body'
      attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Post Your Answer'

      within '.answers' do
        expect(page).to have_content('Answer body')
        expect(page).to have_link('rails_helper.rb')
      end
    end

    scenario 'tries to post answer with several attached file' do
      fill_in 'Your answer', with: 'Answer body'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Post Your Answer'

      within '.answers' do
        expect(page).to have_content('Answer body')
        expect(page).to have_link('rails_helper.rb')
        expect(page).to have_link('spec_helper.rb')
      end
    end

    scenario 'tries to post answer with link' do
      fill_in 'Your answer', with: 'Answer body'
      within "#new-links" do
        click_on 'Add link'

        fill_in 'Link name', with: 'My Gist'
        fill_in 'Link url', with: gist_url
      end

      click_on 'Post Your Answer'
      expect(page).to have_link 'My Gist', href: gist_url
    end

    scenario 'tries to post answer with invalid links' do
      fill_in 'Your answer', with: 'Answer body'
      within "#new-links" do
        click_on 'Add link'

        fill_in 'Link name', with: 'My Gist'
        fill_in 'Link url', with: 'google'
      end

      click_on 'Post Your Answer'
      expect(page).to have_content 'Links url is invalid'
    end

    scenario 'tries to post answer with empty links' do
      fill_in 'Your answer', with: 'Answer body'
      within "#new-links" do
        click_on 'Add link'

        fill_in 'Link name', with: 'My Gist'
      end

      click_on 'Post Your Answer'
      expect(page).to have_content "Links url can't be blank"
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
