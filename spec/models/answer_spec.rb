require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to :question }
    it { should have_db_column(:question_id).of_type(:integer)}
    it { should belong_to :user }
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_many(:links).dependent(:destroy) }
    it { should accept_nested_attributes_for :links }
    it_behaves_like 'rateable'
    it_behaves_like 'commentable'
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  it { should accept_nested_attributes_for :links }

  describe 'scopes' do
    context 'sort_by_best' do
      let!(:answers) { create_list(:answer, 2) }

      context 'without best answer' do
        it { expect(Answer.sort_by_best).to match_array(answers) }
      end

      context 'with best answer' do
        let!(:best_answer) { create(:answer, best: true) }

        it { expect(Answer.sort_by_best).to match_array([best_answer] + answers) }
      end
    end

    context 'best_answer' do
      let!(:answers) { create_list(:answer, 2) }

      context 'without best answer' do
        it { expect(Answer.best_answer).to match_array [] }
      end

      context 'with best answer' do
        let!(:best_answer) { create(:answer, best: true) }

        it { expect(Answer.best_answer).to match_array [best_answer] }
      end
    end
  end

  describe 'methods' do
    context 'select_best' do
      let(:question) { create(:question, :with_reward) }
      let(:answer) { create(:answer, question: question) }
      let(:best_answer) { create(:answer, question: question, best: true) }

      before { answer.select_best }

      it { expect(answer.reload.best).to be_truthy }
      it { expect(best_answer.reload.best).to be_falsey }
      it { expect(question.reward.user).to eq(answer.user) }
      it { expect(question.reward.user).to_not eq(best_answer.user) }
    end
  end
end
