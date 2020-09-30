FactoryBot.define do
  factory :comment do
    user
    association :commentable, factory: :question

    body { 'comment' }

    trait :empty_body do
      body { '' }
    end
  end
end
