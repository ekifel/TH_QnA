require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should belong_to :user }
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should accept_nested_attributes_for :links }
    it { should have_one(:reward).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many(:subscribers).through(:subscriptions).dependent(:destroy) }
    it_behaves_like 'rateable'
    it_behaves_like 'commentable'
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it { should accept_nested_attributes_for :links }

  describe 'work with files' do
    it 'have many attached file' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'methods' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    context 'best_answer' do
      context 'has best answer' do
        let!(:answer) { create(:answer, question: question, best: true) }

        it { expect(question.best_answer).to eq answer }
      end

      context 'has not best answer' do
        let!(:answer) { create(:answer, question: question, best: false) }

        it { expect(question.best_answer).to eq nil }
      end
    end

    describe '#subscribed?' do
      it 'user subscribed' do
        expect(question).to be_subscribed(user)
      end

      it 'user not subscribed' do
        expect(question).to_not be_subscribed(another_user)
      end
    end

    it '#subscription(user)' do
      expect(question.subscription(user)).to eq question.subscriptions.first
    end
  end
end
