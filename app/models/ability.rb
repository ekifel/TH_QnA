# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
    cannot :read, Reward
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    can [:rate_up, :rate_down, :cancel_vote], [Question, Answer] do |rate|
      !user.is_author?(rate)
    end
    can :read, :all
    can :choose_as_best, Answer, question: { user_id: @user.id }
    can :create, [Question, Answer, Link, Subscription]
    can :update, [Question, Answer], user_id: @user.id
    can :destroy, [Question, Answer, Subscription], user_id: @user.id
    can :destroy, ActiveStorage::Attachment, record: { user_id: @user.id }
    can :destroy, Link, linkable: { user_id: @user.id }
    can :create_comment, [Question, Answer]
    can :me, User, { user_id: user.id }
  end
end
