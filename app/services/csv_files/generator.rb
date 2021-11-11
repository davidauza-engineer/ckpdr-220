# frozen_string_literal: true

require 'csv'

module CsvFiles
  class Generator
    attr_reader :items, :attributes

    def initialize(items:, attributes:)
      @items = items
      @attributes = attributes
    end

    def call
      ::CSV.generate(headers: true) do |csv|
        csv << attributes
        items.each do |item|
          csv << attributes.map { |attr| item.send(attr) }
        end
      end
    end
  end
end
