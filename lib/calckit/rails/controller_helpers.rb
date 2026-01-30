# frozen_string_literal: true

module Calckit
  # Controller helpers for calculator actions
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :calckit_scope if respond_to?(:helper_method)
    end

    private

    # Find a calculator class by slug
    def find_calculator_class(slug)
      Calckit.find(slug)
    end

    # Build a calculator instance from params
    def build_calculator(calculator_class, params_hash = nil)
      params_hash ||= calculator_params_for(calculator_class)
      calculator_class.new(params_hash)
    end

    # Extract permitted params for a calculator
    def calculator_params_for(calculator_class)
      return {} unless params[:calculator]
      permitted = calculator_class.inputs.map(&:name)
      params.require(:calculator).permit(*permitted)
    end

    # Save a calculation result
    def save_calculation(calculator, result, calculation_class: nil)
      return unless Calckit.configuration.save_calculations

      calculation_class ||= "Calculation".safe_constantize
      return unless calculation_class

      scope = calckit_scope
      attrs = {
        calculator_type: calculator.class.calculator_slug.to_s,
        calculator_version: calculator.class.version,
        inputs: calculator.input_values,
        outputs: result
      }

      if scope
        scope.calculations.create!(attrs)
      else
        calculation_class.create!(attrs)
      end
    end

    # Load saved calculations for a calculator
    def load_saved_calculations(calculator_class, limit: 5, calculation_class: nil)
      return [] unless Calckit.configuration.save_calculations

      calculation_class ||= "Calculation".safe_constantize
      return [] unless calculation_class

      scope = calckit_scope
      relation = scope ? scope.calculations : calculation_class
      relation
        .where(calculator_type: calculator_class.calculator_slug.to_s)
        .order(created_at: :desc)
        .limit(limit)
    end

    # Returns the scope for multi-tenancy (e.g., current_account)
    def calckit_scope
      scope_method = Calckit.configuration.scope_method
      return nil unless scope_method

      respond_to?(scope_method, true) ? send(scope_method) : nil
    end
  end
end
