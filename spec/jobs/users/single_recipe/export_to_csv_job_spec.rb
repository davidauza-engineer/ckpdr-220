# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SingleRecipe::ExportToCsvJob, type: :job do
  include ActiveJob::TestHelper
  let(:today) { Date.current.to_s }
  let(:yesterday) { 1.day.ago.to_s }

  describe '#perform_later' do
    context 'with the right arguments' do
      subject { described_class.perform_later(date_from: yesterday, date_to: today) }

      it 'enqueues the job' do
        ActiveJob::Base.queue_adapter = :test
        subject
        expect(described_class).to have_been_enqueued.exactly(:once).on_queue(:high_priority).exactly(:once)
      end

      it 'calls the Users::SingleRecipe::Getter service' do
        allow(Users::SingleRecipe::Getter).to receive(:run!).and_return([])
        expect(Users::SingleRecipe::Getter).to receive(:run!).with(date_from: yesterday, date_to: today)
        perform_enqueued_jobs { subject }
      end

      it 'calls the CsvFiles::Generator service' do
        expect(CsvFiles::Generator).to receive(:run!).with(items: [], attributes: described_class::ATTRIBUTES)
        perform_enqueued_jobs { subject }
      end
    end

    context 'with wrong arguments' do
      subject { described_class.perform_later(date_from: 'yesterday', date_to: 'today') }

      it 'raises an error' do
        expect { perform_enqueued_jobs(subject) }.to raise_error ArgumentError
      end
    end

    context 'with no arguments' do
      subject { described_class.perform_later }

      it 'raises an error' do
        expect { perform_enqueued_jobs(subject) }.to raise_error ArgumentError
      end
    end
  end
end
