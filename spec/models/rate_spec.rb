require 'rails_helper'

RSpec.describe Rate, type: :model do
  context 'associations' do
    it { should belong_to :rateable }
    it { should belong_to :user }
  end

  context 'validations' do
    it { should validate_presence_of :status }
  end
end
