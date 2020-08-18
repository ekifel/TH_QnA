require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to :user }
    it { should have_db_column(:user_id).of_type(:integer) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe 'work with files' do
    it 'have many attached file' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'methods' do
    context 'best_answer' do
      let(:question) { create(:question) }

      context 'has best answer' do
        let!(:answer) { create(:answer, question: question, best: true) }

        it { expect(question.best_answer).to eq answer }
      end

      context 'has not best answer' do
        let!(:answer) { create(:answer, question: question, best: false) }

        it { expect(question.best_answer).to eq nil }
      end
    end
  end
end
