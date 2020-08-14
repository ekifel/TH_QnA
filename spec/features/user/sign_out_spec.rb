require 'rails_helper'

feature 'User can sign out', %q{
  In order to exit from system
  As an authenticated user
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    scenario 'tries to sign out' do
      sign_in(user)
      click_on 'log out'

      expect(page).to have_content 'Signed out successfully.'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to sign out' do
      visit questions_path

      expect(page).to_not have_content 'log out'
    end
  end
end
