# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:recipes).dependent(:destroy) }
  end

  describe 'scopes' do
    describe '#recent' do
      subject { described_class.recent }

      let!(:user_one) { described_class.create }
      let!(:user_two) { described_class.create }

      it { is_expected.to match_array([user_two, user_one]) }
    end
  end
end
