require 'rails_helper'

RSpec.describe User, type: :model do

  subject { described_class.new }

  context 'validations' do
    it { is_expected.to allow_value('longboat').for(:username) }
    it { is_expected.not_to allow_value('longbo@t').for(:username) }
    it { is_expected.not_to allow_value('').for(:username) }
    %w[user_fo THE_USER first.lastfoo.jp].each do |username|
      it { is_expected.to allow_value(username).for(:username) }
    end
    it do
      should validate_length_of(:password).is_at_least(6).is_at_most(128)
    end
  end
  let(:user) { FactoryBot.create(:user) }

  context 'validations' do
    it 'is valid when user is created' do
      expect(user).to be_valid
    end

    it 'is invalid when username is not unique' do
	    user1 = User.new(username: user.username, password: 'MyString')
      expect(user1).to be_invalid
    end

    it 'is invalid when name contains some special characters' do
	    user.username = 'My@String'
	    user.save
      expect(user).to be_invalid
    end

    it 'is invalid when password is short' do
      user.password = 'pass'
      user.save
      expect(user).to be_invalid
    end

    it 'user is not locked by default' do
      expect(user.locked).to be_falsey
    end

    it 'user is not locked by default' do
      expect(user.failed).to eq 0
    end

    context 'responds to its methods' do
      subject { described_class.new }

      it { expect(subject).to respond_to(:locked?) }
      it { expect(subject).to respond_to(:authenticate) }
      it { expect(subject).to respond_to(:locked!) }
      it { expect(subject).to respond_to(:unlocked!) }
      it { expect(subject).to respond_to(:unlocked?) }
      it { expect(subject).to respond_to(:failed_attempt) }
    end
  end

  context 'verify object methods' do
    before do
      allow(user).to receive(:authenticate).and_return(true)
    end

    it 'it have locked to be false' do
      expect(user.locked?).to be_falsey
    end

    it 'it have locked to be false' do
      expect(user.locked!).to be_truthy
      expect(user.reload).to be_valid
    end

    it 'when new user is save' do
	    user = FactoryBot.build(:user)
      expect(user).not_to be_persisted
      expect(user).to be_valid
    end

    it 'user when locked!' do
      user.locked!
      expect(user.reload.locked).to be_truthy
      expect(user.reload.unlocked?).to be_falsey
    end

    it 'user when unlocked!' do
	    user.unlocked!
      expect(user.reload.locked).to be_falsey
      expect(user.reload.failed).to eq 0
    end
  end
  context 'verify methods #failed_attempt' do
    before do
      user.failed = 4
      user.save
    end
    it 'user when failed_attempt!' do
      expect(user.failed_attempt).to be_truthy
      expect(user.reload.locked).to be_truthy
    end
  end
end
