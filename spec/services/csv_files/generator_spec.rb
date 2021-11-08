# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvFiles::Generator do
  describe '#run!' do
    context 'with valid arguments' do
      subject { described_class.run!(items: [], attributes: []) }

      it 'calls the CSV.generate method' do
        expect(CSV).to receive(:generate)
        subject
      end
    end

    context 'without arguments' do
      subject { described_class.run! }

      it { expect { subject }.to raise_error ActiveInteraction::InvalidInteractionError }
    end

    context 'with wrong arguments' do
      subject { described_class.run!(items: 1, atrributes: {}) }

      it { expect { subject }.to raise_error ActiveInteraction::InvalidInteractionError }
    end
  end
end
