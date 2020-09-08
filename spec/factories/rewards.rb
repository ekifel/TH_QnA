FactoryBot.define do
  factory :reward do
    question
    user

    sequence(:title) { |n| "Reward name#{n}" }
    image { fixture_file_upload(Rails.root.join('spec', 'images', 'reward.png')) }
  end
end
