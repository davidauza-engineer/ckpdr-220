# frozen_string_literal: true

class AddBodyToRetentionEmails < ActiveRecord::Migration[6.0]
  def change
    add_column :retention_emails, :body, :text
  end
end
