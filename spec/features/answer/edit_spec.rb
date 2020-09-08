require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:wrong_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background { sign_in user }
    background { visit question_path(question) }

    scenario 'edits his answer' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      within '.answer_errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'edits his answer with attaches file' do
      within "#answer-id-#{answer.id}" do
        click_on 'Edit'
        attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
      end
    end

    scenario 'edits his answer with several attaches file' do
      within "#answer-id-#{answer.id}" do
        click_on 'Edit'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    context 'can delete attachment' do
      given!(:answer) { create(:answer, :with_file, question: question, user: user) }
      given!(:attachment) { answer.files.first }

      scenario 'file deletes' do
        within "#answer-id-#{answer.id}" do
          within '.attachments' do
            click_on 'Delete'

            expect(page).to_not have_content(attachment.filename.to_s)
          end
        end
      end
    end

    context "other user's answer" do
      given!(:wrong_answer) { create(:answer, question: question, user: wrong_user) }

      scenario "tries to edit other user's answer" do
        within "#answer-id-#{wrong_answer.id}" do
          expect(page).to_not have_link 'Edit'
        end
      end
    end

    context 'add links:' do
      given(:url) { 'https://gist.github.com/ekifel/4a058cb88bf37fba63c4d4513b98de77' }

      scenario 'can add link to answer' do
        within '.answers' do
          click_on 'Edit'

          within "#new-links" do
            click_on 'Add link'
            fill_in 'Link name', with: 'My Gist'
            fill_in 'Link url', with: url
          end
        end

        click_on 'Save'
        expect(page).to have_link 'Link name', href: url
      end

      scenario 'can add several links to answer' do
        within '.answers' do
          click_on 'Edit'

          within "#new-links" do
            within first('.nested-fields') do
              click_on 'Add link'
              fill_in 'Link name', with: 'My Gist'
              fill_in 'Link url', with: url
            end

            within '.add_fields' do
              click_on 'Add link'
            end

            within all('.nested-fields')[1] do
              fill_in 'Link name', with: 'My Gist 2'
              fill_in 'Link url', with: url
            end
          end
        end

        expect(page).to have_content 'My Gist'
        expect(page).to have_content 'My Gist 2'
      end
    end
  end
end
