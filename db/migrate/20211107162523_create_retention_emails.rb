# frozen_string_literal: true

class CreateRetentionEmails < ActiveRecord::Migration[6.0]
  def change
    create_table :retention_emails, &:timestamps
  end
end
