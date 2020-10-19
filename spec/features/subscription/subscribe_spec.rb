require 'rails_helper'

feature 'User can subscribe to the question', %q{
   In order to see answers from users
   To see question updates
   I'd like to be able get a subscription
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'subscribe to the question', js: true do
      within '#question' do
        click_on 'SUBSCRIBE'
        expect(page).to have_button 'UNSUBSCRIBE'
      end
    end

    scenario 'subscribe from the question', js: true do
      within '#question' do
        click_on 'UNSUBSCRIBE'
        expect(page).to have_button 'SUBSCRIBE'
      end
    end
  end

  describe 'Unauthenticated user' do
    it 'try subscribe to the question' do
      visit question_path(question)

      within '#question' do
        expect(page).to_not have_button 'SUBSCRIBE'
        expect(page).to_not have_button 'UNSUBSCRIBE'
      end
    end
  end
end
