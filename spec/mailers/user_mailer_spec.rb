# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe '#retention_email' do
    context 'with correct arguments' do
      let(:mail) { described_class.retention_email('test@test.com', 'test') }

      it 'renders the right subject' do
        expect(mail.subject).to eq('Your friends at Cookpad')
      end

      it 'renders the right to' do
        expect(mail.to).to eq(['test@test.com'])
      end

      it 'renders the right body' do
        expect(mail.body.encoded).to match('test')
      end
    end
  end
end
