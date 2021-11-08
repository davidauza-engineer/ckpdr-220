# frozen_string_literal: true

class AddEmailToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email, :string, index: true, unique: true
  end
end
