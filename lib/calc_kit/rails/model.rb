# frozen_string_literal: true

module CalcKit
  # Concern for the Calculation model that stores calculation results
  module Model
    extend ActiveSupport::Concern

    included do
      validates :calculator_type, presence: true
      validates :calculator_version, presence: true
      validates :inputs, presence: true
      validates :outputs, presence: true
    end

    # Returns the calculator class for this calculation
    def calculator_class
      CalcKit.find(calculator_type)
    end

    # Returns a new calculator instance populated with the saved inputs
    def to_calculator
      klass = calculator_class
      return nil unless klass

      klass.new(inputs.symbolize_keys)
    end

    # Check if the calculator version matches the current version
    def version_current?
      klass = calculator_class
      return false unless klass

      klass.version == calculator_version
    end

    # Check if there's a version mismatch
    def version_mismatch?
      !version_current?
    end

    module ClassMethods
      # Scope to filter by calculator type
      def for_calculator(slug)
        where(calculator_type: slug.to_s)
      end
    end
  end
end
