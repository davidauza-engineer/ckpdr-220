# frozen_string_literal: true

class CsvsController < ApplicationController
  def create
    send_data(
      Users::SingleRecipe::ExportToCsvJob.perform_later(date_from: params[:date_from], date_to: params[:date_to]),
      filename: "author-retention-users-#{Time.zone.today}.csv"
    )
  end
end
