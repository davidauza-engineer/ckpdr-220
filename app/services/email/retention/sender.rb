# frozen_string_literal: true

module Email
  module Retention
    class Sender < ActiveInteraction::Base
      string :date_from
      string :date_to
      string :body

      def execute
        recipients = Users::SingleRecipe::Getter.run!(date_from: date_from, date_to: date_to)&.pluck(:email)
        UserMailer.bulk_email(recipients, body)
      end
    end
  end
end
