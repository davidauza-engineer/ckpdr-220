# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Csvs", type: :request do
  describe 'POST /download_csv' do
    subject { response }

    let(:today) { Date.current }
    let(:yesterday) { today - 1.day }
    let(:request) { post csvs_create_path, params: { date_from: yesterday.to_s, date_to: today.to_s } }

    it 'returns a successful status' do
      request
      is_expected.to have_http_status(:ok)
    end

    it 'calls Users::SingleRecipe::ExportToCsvJob' do
      expect(Users::SingleRecipe::ExportToCsvJob)
        .to receive(:perform_later)
              .with(date_from: yesterday.to_s, date_to: today.to_s)
      request
    end
  end
end
