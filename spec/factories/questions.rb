include ActionDispatch::TestProcess

FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      before :create do |question|
        question.files.attach fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")
      end
    end

    trait :with_files do
      before :create do |question|
        question.files.attach fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")
        question.files.attach fixture_file_upload("#{Rails.root}/spec/spec_helper.rb")
      end
    end

    trait :with_reward do
      before :create do |question|
        create(:reward,
               question: question,
               title: 'Reward title',
               image: fixture_file_upload(Rails.root.join('spec', 'images', 'reward.png')))
      end
    end

    trait :with_link do
      before :create do |question|
        create(:link, linkable: question)
      end
    end

    trait :with_links do
      before :create do |question|
        create_list(:link, 3, linkable: question)
      end
    end
  end
end
