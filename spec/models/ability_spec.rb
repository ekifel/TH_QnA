require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Link }
    it { should_not be_able_to :read, Reward }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:another_user) { create :user }
    let(:question) { create(:question, :with_files, user: user) }
    let(:another_question) { create(:question, :with_files, :with_links, user: another_user) }
    let(:answer) { create(:answer, :with_files, user: user, question: question) }
    let(:another_answer) { create(:answer, :with_files, user: another_user, question: another_question) }
    let(:link) { create(:link) }
    let(:subscription) { create(:subscription, question: another_question, user: user) }
    let(:wrong_subscription) { create(:subscription, question: question, user: another_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Voted for resource' do
      it { should_not be_able_to %i[rate_up rate_down cancel_vote], question }
      it { should_not be_able_to %i[rate_up rate_down cancel_vote], answer }
      it { should be_able_to %i[rate_up rate_down cancel_vote], another_question }
      it { should be_able_to %i[rate_up rate_down cancel_vote], another_answer }
    end

    context 'Comment' do
      it { should be_able_to :create_comment, answer }
      it { should be_able_to :create_comment, question }
    end

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, question }
      it { should be_able_to :destroy, question }
      it { should_not be_able_to :update, another_question }
      it { should_not be_able_to :destroy, another_question }
      it { should be_able_to :destroy, question.files.first }
      it { should_not be_able_to :destroy, another_question.files.first }
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: another_question) }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, another_answer }
      it { should_not be_able_to :destroy, another_answer }
      it { should be_able_to :destroy, answer.files.first }
      it { should_not be_able_to :destroy, another_answer.files.first }
      it { should_not be_able_to :destroy, create(:link, linkable: another_answer) }
      it { should be_able_to :destroy, create(:link, linkable: answer) }
      it { should be_able_to :choose_best_answer, another_answer }
      it { should_not be_able_to :choose_best_answer, answer }
    end

    describe 'Subscription' do
      it { should be_able_to :create, Subscription }
      it { should be_able_to :destroy, subscription }
      it { should_not be_able_to :destroy, wrong_subscription }
    end
  end
end
