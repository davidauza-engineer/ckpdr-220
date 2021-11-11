# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze

  def validate_each(record, attribute, value)
    unless value =~ EMAIL_REGEXP
      record.errors.add attribute, (options[:message] || "is not an email")
    end
  end
end
