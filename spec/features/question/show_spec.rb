require 'rails_helper'

feature 'User can see a question', %q{
  In order to see a question from community
  As user
  I'd like to be able to see a question
} do

  given!(:question) { create(:question) }

  background { visit question_path(question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    scenario 'can see a question' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can see a question' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
