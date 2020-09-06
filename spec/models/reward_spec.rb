require 'rails_helper'

RSpec.describe Reward, type: :model do
  context 'associations' do
    it { should belong_to :question }
    it { should belong_to(:user).required(false) }
    it { should have_db_column :question_id }
    it { should have_db_column :user_id }
  end

  context 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :image }
  end
end
