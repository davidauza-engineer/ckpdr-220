# frozen_string_literal: true

class RetentionEmail < ApplicationRecord
  validates :body, presence: true
end
