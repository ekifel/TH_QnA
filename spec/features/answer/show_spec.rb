require 'rails_helper'

feature 'User can see all answers to the question', %q{
  In order to see all answers to the question
  As a user
  I'd like to be able to see answers
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    scenario 'can see answers' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content "#{question.answers.count} Answers"
      answers.each do |answer|
        expect(page).to have_content answer.body
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can see answers' do
      visit question_path(question)

      expect(page).to have_content "#{question.answers.count} Answers"
      answers.each do |answer|
        expect(page).to have_content answer.body
      end
    end
  end
end