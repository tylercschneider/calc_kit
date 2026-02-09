# frozen_string_literal: true

module CalcKit
  # DSL module providing class-level macros for calculator definitions
  module DSL
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        class_attribute :_calculator_name, :_calculator_slug, :_calculator_version,
                        :_inputs, :_outputs, instance_writer: false

        self._inputs = []
        self._outputs = []
      end
    end

    module ClassMethods
      def calculator_name(name = nil)
        if name
          self._calculator_name = name
        else
          _calculator_name
        end
      end

      def calculator_slug(slug = nil)
        if slug
          self._calculator_slug = slug.to_sym
        else
          _calculator_slug
        end
      end

      def version(v = nil)
        if v
          self._calculator_version = v
        else
          _calculator_version
        end
      end

      def input(name, type, **options)
        self._inputs = _inputs + [InputDefinition.new(name, type, options)]

        # Define attribute using ActiveModel::Attributes
        attribute name, type_for_attribute(type)

        # Add validations based on options
        validates name, presence: true if options[:required]

        if options[:min]
          validates name, numericality: { greater_than_or_equal_to: options[:min] }, allow_blank: true
        end

        if options[:max]
          validates name, numericality: { less_than_or_equal_to: options[:max] }, allow_blank: true
        end
      end

      def output(name, type, **options)
        self._outputs = _outputs + [OutputDefinition.new(name, type, options)]
      end

      def inputs
        _inputs
      end

      def outputs
        _outputs
      end

      def input_for(name)
        _inputs.find { |i| i.name == name }
      end

      def output_for(name)
        _outputs.find { |o| o.name == name }
      end

      private

      VALID_INPUT_TYPES = %i[string integer decimal date boolean select].freeze

      def type_for_attribute(type)
        unless VALID_INPUT_TYPES.include?(type)
          raise ArgumentError, "Unknown input type: #{type.inspect}. Valid types: #{VALID_INPUT_TYPES.join(", ")}"
        end

        case type
        when :date then :date
        when :integer then :integer
        when :decimal then :decimal
        when :boolean then :boolean
        when :string, :select then :string
        end
      end
    end
  end
end
