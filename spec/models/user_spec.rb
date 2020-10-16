require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many :rewards }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe ".is_author method" do
    let(:user) { create(:user) }
    let(:class_object) { Struct.new(:user_id) }

    context 'user is author' do
      let(:object) { class_object.new(user.id) }

      it 'is_author?' do
        expect(user).to be_is_author(object)
      end
    end

    context 'user is not author' do
      let(:object) { class_object.new(create(:user).id) }

      it 'is_not_author?' do
        expect(user).to_not be_is_author(object)
      end
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to recieve(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
