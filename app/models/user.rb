# frozen_string_literal: true

class User < ApplicationRecord
  has_many :recipes, dependent: :destroy
  scope :recent, -> { order('created_at DESC') }
  scope :single_recipe_authors, lambda { |date_from: 1.year.ago, date_to: Time.current, page: nil|
                                  joins(:recipes)
                                    .where('recipes.published_at BETWEEN ? AND ?', date_from, date_to)
                                    .group(:id)
                                    .having('COUNT(users.id) = 1')
                                    .recent
                                    .page(page)
                                }
end
