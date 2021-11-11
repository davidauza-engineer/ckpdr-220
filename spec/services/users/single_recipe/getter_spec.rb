# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SingleRecipe::Getter do
  describe '#call' do
    let(:current_date) { Date.current }

    context 'when the params are present' do
      subject { described_class.new(date_from: current_date.to_s, date_to: current_date.to_s).call}

      it 'calls the single_recipe_authors scope with valid params' do
        expect(User).to receive(:single_recipe_authors).with(date_from: current_date, date_to: current_date)
        subject
      end
    end

    context 'when the params are not present' do
      subject { described_class.new(date_from: '', date_to: '').call }

      it 'calls the single_recipe_authors scope with valid params' do
        expect(User).to receive(:single_recipe_authors)
        subject
      end
    end
  end
end
