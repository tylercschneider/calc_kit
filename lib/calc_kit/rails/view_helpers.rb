# frozen_string_literal: true

module CalcKit
  # View helpers for rendering calculator forms and results
  module ViewHelpers
    # Resolve a default value, calling it if it's a proc
    def calc_kit_resolve_default(default)
      default.respond_to?(:call) ? default.call : default
    end

    # Format an output value based on its type
    def calc_kit_format_output(value, type)
      return "" if value.nil?

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
    def calc_kit_input_class(calculator, input)
      base = CalcKit.configuration.default_form_classes[:input]
      error = calculator.errors[input.name].any? ? "border-red-500" : ""
      [base, error].reject(&:blank?).join(" ")
    end

    def calc_kit_label_class
      CalcKit.configuration.default_form_classes[:label]
    end

    def calc_kit_error_class
      CalcKit.configuration.default_form_classes[:error]
    end

    def calc_kit_submit_class
      CalcKit.configuration.default_form_classes[:submit]
    end

    # Returns a warning string if the calculation was made with a different
    # calculator version, or nil if versions match or warnings are disabled.
    def calc_kit_version_warning(calculation)
      return nil unless CalcKit.configuration.warn_on_version_mismatch
      return nil unless calculation.version_mismatch?

      "This calculation was made with a different version of the calculator and may have outdated results."
    end
  end
end
