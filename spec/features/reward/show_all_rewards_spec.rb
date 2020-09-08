require 'rails_helper'

feature 'User can see his rewards', %q{
  In order to see rewards from users
  As a authenticated user
  I'd like to be able to see my rewards
} do
  given!(:user) { create(:user) }
  given(:question1) { create(:question, user: user) }
  given!(:answer1) { create(:answer, user: user, best_answer: true) }
  given!(:reward1) { create(:reward, question: question1, user: user) }

  given(:question2) { create(:question, user: user) }
  given!(:answer2) { create(:answer, user: user, best_answer: true) }
  given!(:reward2) { create(:reward, question: question2, user: user) }

  given(:rewards) { [reward1, reward2] }

  describe 'Authenticated user' do
    background { sign_in(user) }
    scenario 'can see his awards' do
      visit rewards_path

      rewards.each do |reward|
        expect(page).to have_content(reward.question.title)
        expect(page).to have_content(reward.name)
        expect(page).to have_css("img[src*='#{reward.image.filename}']")
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario "can't see rewards" do
      visit rewards_path

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
