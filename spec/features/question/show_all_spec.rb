require 'rails_helper'

feature 'User can see all questions', %q{
  In order to see questions from community
  As user
  I'd like to be able to see all questions
} do

  given!(:questions) { create_list(:question, 3) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    scenario 'can see all questions' do
      visit questions_path
      expect(page).to have_content 'All Questions'

      questions.each do |question|
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can see all questions' do
      visit questions_path
      expect(page).to have_content 'All Questions'

      questions.each do |question|
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end
    end
  end
end