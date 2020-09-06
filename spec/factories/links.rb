FactoryBot.define do
  factory :link do
    association :linkable, factory: :question
    sequence(:name) { |n| "Link name#{n}" }
    url { "https://google.com" }
  end
end
