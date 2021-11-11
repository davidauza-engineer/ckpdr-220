# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Email::Retention::Sender do
  let(:yesterday) { (Date.current - 1.day).to_s }
  let(:current_date) { Date.current.to_s }
  let(:body) { '' }

  describe '#run!' do
    context 'when the date_from param is not sent' do
      subject { described_class.run!(date_to: current_date, body: body) }

      it { expect { subject }.to raise_error ActiveInteraction::InvalidInteractionError }
    end

    context 'when the date_to param is not sent' do
      subject { described_class.run!(date_from: current_date, body: body) }

      it { expect { subject }.to raise_error ActiveInteraction::InvalidInteractionError }
    end

    context 'when the body param is not sent' do
      subject { described_class.run!(date_from: current_date, date_to: current_date) }

      it { expect { subject }.to raise_error ActiveInteraction::InvalidInteractionError }
    end

    context 'when valid params are sent' do
      subject { described_class.run!(date_from: yesterday, date_to: current_date, body: body) }

      before do
        user = User.create
        Recipe.create(user_id: user.id, published_at: Date.current - 12.hours)
      end

      it 'calls the bulk_email UserMailer class function' do
        expect(UserMailer).to receive(:bulk_email).with([], body)
        subject
      end
    end

    context 'when not valid params are sent' do
      subject { described_class.run!(date_from: Date.parse(yesterday), date_to: current_date, body: body) }

      it { expect { subject }.to raise_error ActiveInteraction::InvalidInteractionError }
    end
  end
end
