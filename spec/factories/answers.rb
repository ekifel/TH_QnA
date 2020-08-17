FactoryBot.define do
  sequence :body do |n|
    "MyText#{n}"
  end

  factory :answer do
    body
    question
    user
    best { false }

    trait :invalid do
      body { nil }
    end
  end
end
