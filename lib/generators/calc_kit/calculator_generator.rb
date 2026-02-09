# frozen_string_literal: true

require "rails/generators"
require "rails/generators/base"

module CalcKit
  module Generators
    class CalculatorGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      class_option :skip_test, type: :boolean, default: false,
        desc: "Skip generating test file"

      def create_calculator
        template "calculator.rb.tt", "app/calculators/#{file_name}_calculator.rb"
      end

      def create_test
        return if options[:skip_test]

        template "calculator_test.rb.tt", "test/calculators/#{file_name}_calculator_test.rb"
      end

      private

      def class_name
        file_name.camelize
      end

      def calculator_name
        file_name.titleize
      end

      def calculator_slug
        file_name.underscore
      end
    end
  end
end
