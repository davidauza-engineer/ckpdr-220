# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:users) do
    [
      described_class.create(email: 'email1@email.com'),
      described_class.create(email: 'email2@email.com'),
      described_class.create(email: 'email3@email.com')
    ]
  end
  let(:current_year) { 11.months.ago }
  let(:last_year) { 14.months.ago }
  let(:recipes) do
    [
      Recipe.create(user_id: users[0].id, published_at: current_year),
      Recipe.create(user_id: users[1].id, published_at: last_year),
      Recipe.create(user_id: users[2].id, published_at: current_year),
      Recipe.create(user_id: users[2].id, published_at: current_year)
    ]
  end

  describe 'associations' do
    it { is_expected.to have_many(:recipes).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to allow_value('test@email.com').for(:email) }
    it { is_expected.not_to allow_value('test@email').for(:email) }
    it { is_expected.to validate_length_of(:email).is_at_least(5) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end

  describe '#recent scope' do
    subject { described_class.recent }

    before { users }

    it { is_expected.to match_array([users[2], users[1], users[0]]) }
  end

  describe '#single_recipe_authors scope' do
    before { recipes }

    context 'when no options are passed' do
      subject { described_class.single_recipe_authors }

      it { is_expected.to match_array([users[0]]) }
    end

    context 'when only the date_from option is passed' do
      subject { described_class.single_recipe_authors(date_from: 6.months.ago) }

      it { is_expected.to match_array([]) }
    end

    context 'when only the date_to option is passed' do
      subject { described_class.single_recipe_authors(date_to: 6.months.ago) }

      it { is_expected.to match_array([users[0]]) }
    end

    context 'when only the page option is passed' do
      subject { described_class.single_recipe_authors(page: 2) }

      it { is_expected.to match_array([]) }
    end

    context 'when all the options are passed' do
      subject do
        described_class.single_recipe_authors(date_from: 2.years.ago, date_to: 10.months.ago, page: 1)
      end

      it { is_expected.to match_array([users[1], users[0]]) }
    end

    context 'with a single matching recipe' do
      subject do
        described_class.single_recipe_authors(date_from: 2.years.ago, date_to: 10.months.ago, page: 1)
      end

      let(:recipes) do
        [
          Recipe.create(user_id: users[0].id, published_at: current_year),
          Recipe.create(user_id: users[0].id, published_at: current_year),
          Recipe.create(user_id: users[1].id, published_at: last_year),
          Recipe.create(user_id: users[2].id, published_at: current_year),
          Recipe.create(user_id: users[2].id, published_at: current_year)
        ]
      end

      it { is_expected.to match_array([users[1]]) }
    end
  end
end
