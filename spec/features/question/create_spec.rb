require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'test question'
      fill_in 'Body', with: 'some text'
      click_on 'Save'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'test question'
      expect(page).to have_content 'some text'
    end

    scenario 'asks a question with errors' do
      click_on 'Save'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attrached file' do
      fill_in 'Title', with: 'test question'
      fill_in 'Body', with: 'some text'

      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Save'

      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'asks a question with several files' do
      fill_in 'Title', with: 'test question'
      fill_in 'Body', with: 'some text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    describe 'question with attached links' do
      given(:url) { 'https://google.com' }

      scenario 'asks a question with link' do
        fill_in 'Title', with: 'test question'
        fill_in 'Body', with: 'some text'

        fill_in 'Link name', with: 'link to google'
        fill_in 'Link url', with: url

        click_on 'Save'

        expect(page).to have_link 'link to google', href: url
      end

      scenario 'asks a question with several links', js: true do
        fill_in 'Title', with: 'test question'
        fill_in 'Body', with: 'some text'

        within first('.nested-fields') do
          fill_in 'Link name', with: 'link to google'
          fill_in 'Link url', with: url
        end

        within '.add_fields' do
          click_on 'Add link'
        end

        within all('.nested-fields')[1] do
          fill_in 'Link name', with: 'another link to google'
          fill_in 'Link url', with: url
        end

        click_on 'Save'

        expect(page).to have_link 'link to google', href: url
        expect(page).to have_link 'another link to google', href: url
      end

      scenario 'tries to post question with invalid link' do
        fill_in 'Title', with: 'test question'
        fill_in 'Body', with: 'some text'

        fill_in 'Link name', with: 'link to google'
        fill_in 'Link url', with: 'hehe'

        click_on 'Save'

        expect(page).to have_content 'Links url is invalid'
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
