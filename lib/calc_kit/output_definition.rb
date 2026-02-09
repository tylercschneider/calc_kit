# frozen_string_literal: true

module CalcKit
  # Value object for output field definitions
  class OutputDefinition
    attr_reader :name, :type, :options

    def initialize(name, type, options = {})
      @name = name
      @type = type
      @options = options
    end

    def label
      options[:label] || name.to_s.tr("_", " ").capitalize
    end

    def format
      options[:format]
    end

    def ==(other)
      other.is_a?(OutputDefinition) &&
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
