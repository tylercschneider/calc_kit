# frozen_string_literal: true

module Calckit
  # Registry for calculator lookup by slug
  class Registry
    def initialize
      @calculators = {}
    end

    def register(calculator_class)
      slug = calculator_class.calculator_slug
      raise ArgumentError, "Calculator must define a slug" unless slug

      @calculators[slug.to_sym] = calculator_class
    end

    def find(slug)
      @calculators[slug.to_sym]
    end

    def all
      @calculators.values
    end

    def slugs
      @calculators.keys
    end

    def clear
      @calculators.clear
    end

    def registered?(slug)
      @calculators.key?(slug.to_sym)
    end
  end
end
