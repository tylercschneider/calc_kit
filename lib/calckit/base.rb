# frozen_string_literal: true

require "active_model"

module Calckit
  # Base class for all calculators with a declarative DSL
  #
  # Responsibilities (Single Responsibility):
  # - Defines DSL for declaring calculator metadata, inputs, and outputs
  # - Provides validation through ActiveModel
  #
  # Open/Closed: New calculators extend this class without modifying it
  # Liskov Substitution: All subclasses can be used interchangeably via #run
  # Interface Segregation: InputDefinition and OutputDefinition are separate classes
  # Dependency Inversion: Uses ActiveModel abstractions, not concrete implementations
  #
  class Base
    include ActiveModel::Model
    include ActiveModel::Attributes
    include DSL

    # Run calculation if valid, return nil if invalid
    def run
      return nil unless valid?
      calculate
    end

    # Run calculation, raise if invalid
    def run!
      raise ActiveModel::ValidationError, self unless valid?
      calculate
    end

    # Subclasses must implement this
    def calculate
      raise NotImplementedError, "#{self.class.name} must implement #calculate"
    end

    # Returns input values as a hash
    def input_values
      self.class.inputs.each_with_object({}) do |input, hash|
        hash[input.name] = send(input.name)
      end
    end

    # Returns the calculator name
    def calculator_name
      self.class.calculator_name
    end

    # Returns the calculator slug
    def calculator_slug
      self.class.calculator_slug
    end

    # Returns the calculator version
    def version
      self.class.version
    end
  end
end
