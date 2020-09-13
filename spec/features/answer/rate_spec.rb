require 'rails_helper'

feature 'User can rate answer', %q{
   In order to rate answer
   As a authenticated user
   I'd like to ba able to rate the answer
 } do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }

  describe 'Authenticated user', js: true do
    given!(:question) { create(:question, user: user) }
    given!(:answer) { create(:answer, question: question, user: user) }

    background { sign_in(another_user) }
    background { visit question_path(question) }

    context 'is not answer owner' do
      scenario 'can rate up' do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
            within '.rate-actions' do
              expect(page).to have_link '+'

              click_on '+'
            end

            within '.answer-rating' do
              expect(page).to have_content(answer.reload.rating)
            end
          end
        end
      end

      scenario 'can rate down' do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
            within '.rate-actions' do
              expect(page).to have_link '-'

              click_on '-'
            end

            within '.answer-rating' do
              expect(page).to have_content(answer.reload.rating)
            end
          end
        end
      end

      context 'when user already has a vote' do
        given!(:rate) { create(:rate, rateable: answer, user: another_user) }

        scenario 'can cancel his vote' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
              within '.rate-actions' do
                expect(page).to have_link 'cancel vote'

                click_on 'cancel vote'
              end

              within '.answer-rating' do
                expect(page).to have_content(answer.reload.rating)
              end
            end
          end
        end
      end

      context 'with someone else rate' do
        given!(:rate) { create(:rate, ratable: answer, status: 1) }

        scenario 'can rate up' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
              within '.rate-actions' do
                expect(page).to have_link '+'

                click_on '+'
              end

              within '.answer-rating' do
                expect(page).to have_content(answer.reload.rating)
              end
            end
          end
        end

        scenario 'can rate down' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
              within '.rate-actions' do
                expect(page).to have_link '-'

                click_on '-'
              end

              within '.answer-rating' do
                expect(page).to have_content(answer.reload.rating)
              end
            end
          end
        end
      end
    end

    context 'is answer owner' do
      background { sign_in(user) }

      scenario "can't rate his answer" do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
            within '.rate-actions' do
              expect(page).to_not have_link '+'
              expect(page).to_not have_link '-'
              expect(page).to_not have_link 'cancel vote'
            end
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
      within '.answers' do
        within "#answer-id-#{answer.id}" do
          expect(page).to_not have_css('.rate-actions')

          within '.answer-rating' do
            expect(page).to have_content(answer.reload.rating)
          end
        end
      end
    end
  end
end
