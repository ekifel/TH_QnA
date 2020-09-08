require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:question) { create(:question, user: user) }
    background { sign_in user }
    background { visit question_path(question) }

    scenario 'edits his question' do
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: 'new title'
        fill_in 'Body', with: 'new body'
        click_on 'Save'

        expect(page).to have_content 'new title'
        expect(page).to have_content 'new body'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with mistakes' do
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'
      end

      within '.question_errors' do
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content "Title can't be blank"
      end
    end

    context "tries to edit" do
      given!(:wrong_question) { create(:question, user: create(:user)) }

      scenario "other user's question" do
        visit question_path(wrong_question)

        within '.question' do
          expect(page).to_not have_link 'Edit'
        end
      end
    end

    scenario 'edits his question with attaches file' do
      within ".question" do
        click_on 'Edit'
        attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
      end
    end

    scenario 'edits his question with several attaches file' do
      within ".question" do
        click_on 'Edit'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    context 'can delete attachment' do
      given!(:question) { create(:question, :with_file, user: user) }
      given!(:attachment) { question.files.first }

      scenario 'file deletes' do
        within ".question" do
          within "#attachment-id-#{attachment.id}" do
            click_on 'Delete'
          end
          expect(page).to_not have_content(attachment.filename.to_s)
        end
      end
    end

    describe 'edit attached links' do
      given(:url) { 'https://google.com' }

      scenario 'tries to add link' do
        within '.question' do
          click_on 'Edit'

          fill_in 'Link name', with: 'link to google'
          fill_in 'Link url', with: url

          click_on 'Save'
        end

        expect(page).to have_link 'link to google', href: url
      end

      scenario 'tries to add several links' do
        within '.question' do
          within first('.nested-fields') do
            fill_in 'Link name', with: 'link to google'
            fill_in 'Link url', with: url
          end

          within '.add_fields' do
            click_on 'Add link'
          end

          within all('.nested-fields')[1] do
            fill_in 'Link name', with: 'another link to google'
            fill_in 'Link url', with: url
          end

          click_on 'Save'
        end

        expect(page).to have_link 'link to google', href: url
        expect(page).to have_link 'another link to google', href: url
      end

      context 'tries to delete attached link' do
        given!(:question) { create(:question, :with_link, user: user) }

        scenario 'link successfully deleted' do
          within '.question' do
            click_on 'Edit'
            click_on 'Delete link'
            click_on 'Save'
          end

          expect(page).to_not have_content question.links.first.name
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    given!(:question) { create(:question) }
    scenario 'tries to edit question' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
