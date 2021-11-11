# frozen_string_literal: true

module Email
  module Retention
    class Sender
      attr_reader :date_from, :date_to, :body

      def initialize(date_from:, date_to:, body:)
        @date_from = date_from
        @date_to = date_to
        @body = body
      end

      def call
        recipients = Users::SingleRecipe::Getter.new(date_from: date_from, date_to: date_to).call.pluck(:email)
        UserMailer.bulk_email(recipients, body)
      end
    end
  end
end
