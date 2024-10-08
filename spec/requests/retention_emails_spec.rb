# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RetentionEmails', type: :request do
  subject { response }

  let(:today) { Date.current }
  let(:yesterday) { today - 1.day }

  describe 'GET /index' do
    let(:request) { get retention_emails_path }

    before { request }

    it { expect(assigns(:emails)).to eq(RetentionEmail.all) }
    it { is_expected.to render_template(:index) }
  end

  describe 'GET /new' do
    let(:request) do
      get new_retention_email_path, params: { date_from: yesterday, date_to: today }
    end

    before { request }

    it { is_expected.to have_http_status(:ok) }

    it { expect(assigns(:email)).to be_a_new(RetentionEmail) }

    it { is_expected.to render_template(:new) }

    context 'when both date_from and date_to params are sent' do
      it { expect(assigns(:users)).not_to be_nil }
    end
  end

  describe 'POST /create' do
    let(:params) { { retention_email: { body: 'test' }, date_from: yesterday, date_to: today } }
    let(:request) { post retention_emails_path, params: params }

    context 'response' do
      before { request }

      it { is_expected.to have_http_status(:found) }

      it { expect(flash[:notice]).to match(/Emails will be sent shortly!*/) }
    end

    context 'with the correct params' do
      subject { request }

      it { expect { subject }.to change(RetentionEmail, :count).by(1) }

      it 'calls the Email::Retention::Sender service' do
        expect_any_instance_of(Email::Retention::Sender).to receive(:call)
        subject
      end
    end

    context 'with incorrect params' do
      let(:params) { { retention_email: { body: nil }, date_from: yesterday, date_to: today } }

      before { request }

      it { is_expected.to have_http_status(:found) }

      it { expect(flash[:notice]).to match(/Something went wrong!*/) }
    end
  end
end
