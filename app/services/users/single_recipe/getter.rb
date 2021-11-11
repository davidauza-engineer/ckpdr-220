# frozen_string_literal: true

module Users
  module SingleRecipe
    class Getter
      attr_reader :date_from, :date_to

      def initialize(date_from:, date_to:)
        @date_from = date_from
        @date_to = date_to
      end

      def call
        if date_from.present? && date_to.present?
          User.single_recipe_authors(date_from: Date.parse(date_from), date_to: Date.parse(date_to))
        else
          User.single_recipe_authors
        end
      end
    end
  end
end
