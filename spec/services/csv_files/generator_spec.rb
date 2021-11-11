# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvFiles::Generator do
  describe '#call' do
    context 'with valid arguments' do
      subject { described_class.new(items: [], attributes: []).call }

      it 'calls the CSV.generate method' do
        expect(CSV).to receive(:generate)
        subject
      end
    end
  end
end
