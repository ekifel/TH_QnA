require 'rails_helper'

feature 'User can register', %q{
  In order to login and ask questions/give answers
  As an authenticated user
  I'd like to be able to register
} do

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    scenario 'tries to register' do
      sign_in(user)
      visit new_user_registration_path

      expect(page).to have_content 'You are already signed in.'
    end
  end

  describe 'Registered user' do
    given!(:user) { create(:user) }

    scenario 'tries to register' do
      visit new_user_registration_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_on 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end
  end

  describe 'Unregistred user' do

    background { visit new_user_registration_path }

    context 'tries to register' do
      scenario 'with correct attributes' do
        fill_in 'Email', with: 'test@mail.com'
        fill_in 'Password', with: '12345678'
        fill_in 'Password confirmation', with: '12345678'
        click_on 'Sign up'

        expect(page).to have_content 'Welcome! You have signed up successfully.'
      end

      scenario 'with wrong email' do
        fill_in 'Email', with: 'blablabla'
        click_on 'Sign up'

        expect(page).to have_content 'Email is invalid'
      end

      scenario 'with empty password field' do
        fill_in 'Email', with: 'test@mail.com'
        click_on 'Sign up'

        expect(page).to have_content "Password can't be blank"
      end

      scenario 'with wrong password confirmation' do
        fill_in 'Email', with: 'test@mail.com'
        fill_in 'Password', with: '12345678'
        fill_in 'Password confirmation', with: '123456789'
        click_on 'Sign up'

        expect(page).to have_content "Password confirmation doesn't match Password"
      end
    end
  end
end
