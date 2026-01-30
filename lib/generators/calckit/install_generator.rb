# frozen_string_literal: true

require "rails/generators"
require "rails/generators/base"

module Calckit
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      class_option :model, type: :boolean, default: false,
        desc: "Generate Calculation model and migration"
      class_option :views, type: :boolean, default: false,
        desc: "Copy default views to app/views/calculators"
      class_option :scope, type: :string, default: nil,
        desc: "Multi-tenancy scope method (e.g., current_account)"

      def create_initializer
        template "initializer.rb.tt", "config/initializers/calckit.rb"
      end

      def create_calculators_directory
        empty_directory "app/calculators"
      end

      def create_application_calculator
        template "application_calculator.rb.tt", "app/calculators/application_calculator.rb"
      end

      def create_model
        return unless options[:model]

        template "calculation.rb.tt", "app/models/calculation.rb"
        migration_template "create_calculations.rb.tt",
          "db/migrate/create_calculations.rb",
          migration_version: migration_version
      end

      def copy_views
        return unless options[:views]

        directory "views", "app/views/calculators"
      end

      def show_post_install_message
        say ""
        say "Calckit installed successfully!", :green
        say ""
        say "Next steps:"
        say "  1. Run `rails db:migrate` if you generated the model"
        say "  2. Create a calculator: `rails g calckit:calculator my_calculator`"
        say "  3. Define inputs, outputs, and the calculate method"
        say "  4. Register your calculator at the bottom of the file"
        say ""
      end

      private

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
      end

      def scope_method
        options[:scope]
      end
    end
  end
end
