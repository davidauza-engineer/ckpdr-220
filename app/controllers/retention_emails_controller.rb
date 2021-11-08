# frozen_string_literal: true

class RetentionEmailsController < ApplicationController

  def new
    @email = RetentionEmail.new
    date_from = params[:date_from]
    date_to = params[:date_to]
    if date_from.present? && date_to.present?
      @users = User.single_recipe_authors(date_from: Date.parse(date_from), date_to: Date.parse(date_to))
    end
  end

  def create
    @email = RetentionEmail.new(retention_email_params)

    users = get_users
    recipients = []
    users.each do |user|
      recipients << user.email
    end

    if @email.save && send_mail(recipients)
      redirect_to retention_emails_path, notice: "Emails Sent Successfully!"
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

  def send_mail(recipients)
    recipients.each do |r|
      UserMailer.bulk_email(r).deliver_later
    end
  end

  def get_users
    @users = User.recent.joins(:recipes).group("recipes.user_id").where("`published_recipes_count` = 1").
      where("published_at Between ? AND ?", Date.parse(params[:date_from]), Date.parse(params[:date_to])).page(params[:page])
  end

  def retention_email_params
    params.permit(:body, :date_from, :date_to)
  end
end
