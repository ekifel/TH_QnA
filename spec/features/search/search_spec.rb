require 'sphinx_helper'

feature 'Every user can search', %q{
   In order to find an interesting question, answer, comment, user
   As a user
    I want to be able to search
} do
  given!(:user) { create(:user, email: 'test@gmail.com') }
  given!(:question) { create(:question, title: 'question test') }
  given!(:answer) { create(:answer, body: 'answer test') }
  given!(:comment) { create(:comment, commentable: question, user: user, body: 'comment test') }

  before { visit root_path }

  describe 'filled body in request' do
    scenario 'search in questions section', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_q', with: question.title
        select 'questions', from: 'search_section'
        click_on 'Search'

        within '.search-results' do
          expect(page).to have_content question.title
        end
      end
    end

    scenario 'search in answers section', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_q', with: answer.body
        select 'answers', from: 'search_section'
        click_on 'Search'

        within '.search-results' do
          expect(page).to have_content answer.body
        end
      end
    end

    scenario 'search in comments section', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_q', with: comment.body
        select 'comments', from: 'search_section'
        click_on 'Search'

        within '.search-results' do
          expect(page).to have_content comment.body
        end
      end
    end

    scenario 'search in users section', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_q', with: user.email
        select 'users', from: 'search_section'
        click_on 'Search'

        within '.search-results' do
          expect(page).to have_content user.email
        end
      end
    end

    scenario 'search in all sections', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_q', with: 'test'
        select 'all', from: 'search_section'
        click_on 'Search'

        within '.search-results' do
          expect(page).to have_content user.email
          expect(page).to have_content answer.body
          expect(page).to have_content comment.body
          expect(page).to have_content user.email
          expect(page).to have_content question.title
        end
      end
    end
  end

  describe 'empty body in request' do
    scenario 'search in questions section', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_q', with: ''
        select 'questions', from: 'search_section'
        click_on 'Search'

        within '.search-results' do
          expect(page).to_not have_content question.title
          expect(page).to have_content 'Вы выполнили пустой запрос'
        end
      end
    end

    scenario 'search in answers section', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_q', with: ''
        select 'answers', from: 'search_section'
        click_on 'Search'

        within '.search-results' do
          expect(page).to_not have_content answer.body
          expect(page).to have_content 'Вы выполнили пустой запрос'
        end
      end
    end

    scenario 'search in comments section', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_q', with: ''
        select 'comments', from: 'search_section'
        click_on 'Search'

        within '.search-results' do
          expect(page).to_not have_content comment.body
          expect(page).to have_content 'Вы выполнили пустой запрос'
        end
      end
    end

    scenario 'search in users section', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_q', with: ''
        select 'users', from: 'search_section'
        click_on 'Search'

        within '.search-results' do
          expect(page).to_not have_content user.email
          expect(page).to have_content 'Вы выполнили пустой запрос'
        end
      end
    end

    scenario 'search in all sections', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'search_q', with: ''
        select 'all', from: 'search_section'
        click_on 'Search'

        within '.search-results' do
          expect(page).to_not have_content user.email
          expect(page).to_not have_content answer.body
          expect(page).to_not have_content comment.body
          expect(page).to_not have_content user.email
          expect(page).to_not have_content question.title
          expect(page).to have_content 'Вы выполнили пустой запрос'
        end
      end
    end
  end
end
