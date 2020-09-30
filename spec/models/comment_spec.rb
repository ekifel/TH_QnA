require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:commentable) }

    it { should have_db_column(:commentable_id) }
    it { should have_db_column(:user_id) }
  end

  context 'validations' do
    it { should validate_presence_of(:body) }
  end
end
