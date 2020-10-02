require 'rails_helper'

feature 'User can sign in with another resources authorization', %q(
 In order to use website's opportunities as an unauthenticated user
 I'd like to able to authorization from social networks
) do
  %w[github vkontakte].each do |network|
    let(:user) { create(:user) }
    background do
      visit new_user_session_path
      clean_mock_auth(network)
    end

    describe 'Registered user' do
      scenario 'try to sign in' do
        mock_auth_hash(network, email: 'test@mail.ru')
        click_on "Sign in with #{network}"
        expect(page).to have_content "Successfully authenticated from #{network} account."
      end

      scenario 'try to sign in with failture' do
        failture_mock_auth(network)
        click_on "Sign in with #{network}"
        expect(page).to have_content "Could not authenticate you from #{network} because \"Invalid credentials\"."
      end
    end

    describe 'Unregistred user' do
      scenario 'try to sign in' do
        mock_auth_hash(network, email: 'test@mail.ru')
        click_on "Sign in with #{network}"
        expect(page).to have_content "Successfully authenticated from #{network} account."
      end
    end
  end
end
