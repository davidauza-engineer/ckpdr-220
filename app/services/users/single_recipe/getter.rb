# frozen_string_literal: true

module Users
  module SingleRecipe
    class Getter < ActiveInteraction::Base
      string :date_from
      string :date_to

      def execute
        if date_from.present? && date_to.present?
          User.single_recipe_authors(date_from: Date.parse(date_from), date_to: Date.parse(date_to))
        else
          User.single_recipe_authors
        end
      end
    end
  end
end
