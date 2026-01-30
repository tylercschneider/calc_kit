# frozen_string_literal: true

module Calckit
  # Value object for input field definitions
  class InputDefinition
    attr_reader :name, :type, :options

    def initialize(name, type, options = {})
      @name = name
      @type = type
      @options = options
    end

    def label
      options[:label] || name.to_s.tr("_", " ").capitalize
    end

    def required?
      options[:required] == true
    end

    def default
      options[:default]
    end

    def placeholder
      options[:placeholder]
    end

    def min
      options[:min]
    end

    def max
      options[:max]
    end

    def step
      options[:step]
    end

    def options_for_select
      options[:options]
    end

    def hint
      options[:hint]
    end

    def ==(other)
      other.is_a?(InputDefinition) &&
        name == other.name &&
        type == other.type &&
        options == other.options
    end

    alias_method :eql?, :==

    def hash
      [name, type, options].hash
    end
  end
end
