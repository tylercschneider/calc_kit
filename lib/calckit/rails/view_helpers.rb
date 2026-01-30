# frozen_string_literal: true

module Calckit
  # View helpers for rendering calculator forms and results
  module ViewHelpers
    # Resolve a default value, calling it if it's a proc
    def calckit_resolve_default(default)
      default.respond_to?(:call) ? default.call : default
    end

    # Format an output value based on its type
    def calckit_format_output(value, type)
      case type
      when :date
        value&.respond_to?(:to_fs) ? value.to_fs(:long) : value.to_s
      when :decimal
        if respond_to?(:number_with_precision)
          number_with_precision(value, precision: 2)
        else
          format("%.2f", value.to_f)
        end
      when :integer
        value.to_i.to_s
      when :currency
        if respond_to?(:number_to_currency)
          number_to_currency(value)
        else
          format("$%.2f", value.to_f)
        end
      when :percentage
        if respond_to?(:number_to_percentage)
          number_to_percentage(value, precision: 1)
        else
          format("%.1f%%", value.to_f)
        end
      else
        value.to_s
      end
    end

    # CSS classes for form elements
    def calckit_input_class(calculator, input)
      base = Calckit.configuration.default_form_classes[:input]
      error = calculator.errors[input.name].any? ? "border-red-500" : ""
      [base, error].reject(&:blank?).join(" ")
    end

    def calckit_label_class
      Calckit.configuration.default_form_classes[:label]
    end

    def calckit_error_class
      Calckit.configuration.default_form_classes[:error]
    end

    def calckit_submit_class
      Calckit.configuration.default_form_classes[:submit]
    end
  end
end
