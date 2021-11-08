# frozen_string_literal: true

class AddPublishedAtToRecipes < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :published_at, :date, index: true
  end
end
