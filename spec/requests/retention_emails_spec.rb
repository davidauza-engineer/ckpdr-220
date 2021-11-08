# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RetentionEmails', type: :request do
  describe 'GET /new' do
    subject { response }

    let(:request) { get new_retention_emails_path }
    let(:today) { Date.current }
    let(:yesterday) { today - 1.day }

    before { request }

    it { is_expected.to have_http_status(:ok) }

    it { expect(assigns(:email)).to be_a_new(RetentionEmail) }

    it { is_expected.to render_template(:new) }

    context 'when no params are sent' do
      it { expect(assigns(:users)).to be_nil }
    end

    context 'when only the date_from param is sent' do
      let(:request) { get new_retention_emails_path, params: { date_from: yesterday } }

      it { expect(assigns(:users)).to be_nil }
    end

    context 'when only the date_to param is sent' do
      let(:request) { get new_retention_emails_path, params: { date_to: today } }

      it { expect(assigns(:users)).to be_nil }
    end

    context 'when both date_from and date_to params are sent' do
      let(:request) do
        get new_retention_emails_path, params: { date_from: yesterday, date_to: today }
      end

      it { expect(assigns(:users)).not_to be_nil }
    end
  end
end
