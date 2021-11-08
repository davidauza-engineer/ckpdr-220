# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def self.bulk_email(recipients, body)
    recipients&.each do |recipient|
      retention_email(recipient, body)&.deliver_later
    end
  end

  def retention_email(recipient, body)
    mail(to: recipient, subject: 'Your friends at Cookpad', body: body)
  end
end
