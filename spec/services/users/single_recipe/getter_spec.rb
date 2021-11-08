# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SingleRecipe::Getter do
  describe '#run!' do
    let(:current_date) { Date.current }

    context 'when no params are passed' do
      subject { described_class.run! }

      it { expect { subject }.to raise_error ActiveInteraction::InvalidInteractionError }
    end

    context 'when the date_from param is not passed' do
      subject { described_class.run!(date_to: current_date) }

      it { expect { subject }.to raise_error ActiveInteraction::InvalidInteractionError }
    end

    context 'when the date_to param is not passed' do
      subject { described_class.run!(date_from: current_date) }

      it { expect { subject }.to raise_error ActiveInteraction::InvalidInteractionError }
    end

    context 'when the params are present' do
      subject { described_class.run!(date_from: current_date.to_s, date_to: current_date.to_s) }

      it 'calls the single_recipe_authors scope with valid params' do
        expect(User).to receive(:single_recipe_authors).with(date_from: current_date, date_to: current_date)
        subject
      end
    end

    context 'when the params are not present' do
      subject { described_class.run!(date_from: '', date_to: '') }

      it 'calls the single_recipe_authors scope with valid params' do
        expect(User).to receive(:single_recipe_authors)
        subject
      end
    end

    context 'when the params are not valid' do
      subject { described_class.run!(date_from: current_date, date_to: current_date) }

      it { expect { subject }.to raise_error ActiveInteraction::InvalidInteractionError }
    end
  end
end
