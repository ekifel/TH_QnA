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

    trait :with_file do
      before :create do |answer|
        answer.files.attach fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")
      end
    end

    trait :with_files do
      before :create do |answer|
        answer.files.attach fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")
        answer.files.attach fixture_file_upload("#{Rails.root}/spec/spec_helper.rb")
      end
    end

    trait :with_link do
      before :create do |answer|
        create(:link, linkable: answer)
      end
    end

    trait :with_links do
      before :create do |answer|
        create_list(:link, 3, linkable: answer)
      end
    end
  end
end
