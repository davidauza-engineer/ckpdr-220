# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Email::Retention::Sender do
  let(:yesterday) { (Date.current - 1.day).to_s }
  let(:current_date) { Date.current.to_s }
  let(:body) { '' }

  describe '#call' do
    context 'when valid params are sent' do
      subject { described_class.new(date_from: yesterday, date_to: current_date, body: body).call }

      before do
        user = User.create
        Recipe.create(user_id: user.id, published_at: Date.current - 12.hours)
      end

      it 'calls the bulk_email UserMailer class function' do
        expect(UserMailer).to receive(:bulk_email).with([], body)
        subject
      end
    end
  end
end
