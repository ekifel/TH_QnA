require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to :question }
    it { should have_db_column(:question_id).of_type(:integer)}
    it { should belong_to :user }
    it { should have_db_column(:user_id).of_type(:integer) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end
end
