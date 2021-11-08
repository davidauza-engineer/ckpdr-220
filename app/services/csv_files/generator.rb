# frozen_string_literal: true

require 'csv'

module CsvFiles
  class Generator < ActiveInteraction::Base
    array :items
    array :attributes

    def execute
      ::CSV.generate(headers: true) do |csv|
        csv << attributes
        items.each do |item|
          csv << attributes.map { |attr| item.send(attr) }
        end
      end
    end
  end
end
