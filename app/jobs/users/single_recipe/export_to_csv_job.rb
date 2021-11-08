# frozen_string_literal: true

module Users
  module SingleRecipe
    class ExportToCsvJob < ApplicationJob
      ATTRIBUTES = %w[id email name].freeze

      queue_as :high_priority

      def perform(date_from:, date_to:)
        users = Users::SingleRecipe::Getter.run!(date_from: date_from, date_to: date_to)
        CsvFiles::Generator.run!(items: users, attributes: ATTRIBUTES)
      end
    end
  end
end
