FactoryBot.define do
  factory :rate do
    user
    association :rateable, factory: :question

    status { 0 }
  end
end
