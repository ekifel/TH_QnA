require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
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
      scenario "tries to edit other user's answer" do
        within "#answer-id-#{wrong_answer.id}" do
          expect(page).to_not have_link 'Edit'
        end
      end
    end
  end
end
