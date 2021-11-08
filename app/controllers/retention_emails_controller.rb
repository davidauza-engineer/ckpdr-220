# frozen_string_literal: true

class RetentionEmailsController < ApplicationController

  def index
    @emails = RetentionEmail.all
  end

  def new
    @email = RetentionEmail.new
    @users = Users::SingleRecipe::Getter.run!(date_from: params[:date_from], date_to: params[:date_to])
  end

  def create
    valid_params = retention_email_params
    @email = RetentionEmail.new(valid_params)

    if @email.save
      Email::Retention::Sender.run!(date_from: params[:date_from], date_to: params[:date_to], body: valid_params[:body])
      redirect_to retention_emails_url, notice: 'Emails will be sent shortly!'
    else
      redirect_to retention_emails_url, notice: 'Something went wrong!'
    end
  end

  def download_csv
    users = get_users
    send_data to_csv(users), filename: "author-retention-users-#{Time.zone.today}.csv"
  end

  private

  def to_csv(data)
    attributes = %w{id email name}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      data.each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end

  def get_users
    @users = User.recent.joins(:recipes).group("recipes.user_id").where("`published_recipes_count` = 1").
      where("published_at Between ? AND ?", Date.parse(params[:date_from]), Date.parse(params[:date_to])).page(params[:page])
  end

  def retention_email_params
    params.require(:retention_email).permit(:body)
  end
end
