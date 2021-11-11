# frozen_string_literal: true

class RetentionEmailsController < ApplicationController
  def index
    @emails = RetentionEmail.all
  end

  def new
    @email = RetentionEmail.new
    @users = Users::SingleRecipe::Getter.new(date_from: params[:date_from], date_to: params[:date_to]).call
  end

  def create
    valid_params = retention_email_params
    @email = RetentionEmail.new(valid_params)

    if @email.save
      Email::Retention::Sender.new(date_from: params[:date_from], date_to: params[:date_to], body: valid_params[:body]).call
      redirect_to retention_emails_url, notice: 'Emails will be sent shortly!'
    else
      redirect_to retention_emails_url, notice: 'Something went wrong!'
    end
  end

  private

    def retention_email_params
      params.require(:retention_email).permit(:body)
    end
end
