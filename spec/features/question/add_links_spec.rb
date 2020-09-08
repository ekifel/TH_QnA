require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/ekifel/4a058cb88bf37fba63c4d4513b98de77' }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Link url', with: gist_url

    click_on 'Save'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
