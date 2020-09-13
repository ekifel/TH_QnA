require 'rails_helper'

feature 'User can rate question', %q{
   In order to rate question
   As a authenticated user
   I'd like to ba able to rate the question
 } do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }

  describe 'Authenticated user', js: true do
    given!(:question) { create(:question, user: user) }
    given!(:answer) { create(:answer, question: question, user: user) }

    background { sign_in(another_user) }
    background { visit question_path(question) }

    context 'is not question owner' do
      scenario 'can rate up' do
        within '.question' do
          within ".question-rates" do
            within '.rate-actions' do
              expect(page).to have_link '+'

              click_on '+'
            end

            within '.question-rating' do
              expect(page).to have_content(question.reload.rating)
            end
          end
        end
      end

      scenario 'can rate down' do
        within '.question' do
          within ".question-rates" do
            within '.rate-actions' do
              expect(page).to have_link '-'

              click_on '-'
            end

            within '.question-rating' do
              expect(page).to have_content(question.reload.rating)
            end
          end
        end
      end

      context 'when user already has a vote' do
        given!(:rate) { create(:rate, rateable: question, user: another_user) }

        scenario 'can cancel his vote' do
          within '.question' do
            within ".question-rates" do
              within '.rate-actions' do
                expect(page).to have_link 'cancel vote'

                click_on 'cancel vote'
              end

              within '.question-rating' do
                expect(page).to have_content(question.reload.rating)
              end
            end
          end
        end
      end

      context 'with someone else rate' do
        given!(:rate) { create(:rate, ratable: question, status: 1) }

        scenario 'can rate up' do
          within '.question' do
            within ".question-rates" do
              within '.rate-actions' do
                expect(page).to have_link '+'

                click_on '+'
              end

              within '.question-rating' do
                expect(page).to have_content(question.reload.rating)
              end
            end
          end
        end

        scenario 'can rate down' do
          within '.question' do
            within ".question-rates" do
              within '.rate-actions' do
                expect(page).to have_link '-'

                click_on '-'
              end

              within '.question-rating' do
                expect(page).to have_content(question.reload.rating)
              end
            end
          end
        end
      end
    end

    scenario 'is question owner' do
      within '.question' do
        within ".question-rates" do
          within '.rate-actions' do
            expect(page).to_not have_link '+'
            expect(page).to_not have_link '-'
            expect(page).to_not have_link 'cancel vote'
          end
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    given!(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }

    background { visit question_path(question) }

    scenario 'can not rates' do
      within '.question' do
        within ".question-rates" do
          expect(page).to_not have_css('.rate-actions')

          within '.question-rating' do
            expect(page).to have_content(question.reload.rating)
          end
        end
      end
    end
  end
end
