# frozen_string_literal: true

module Calckit
  class Engine < ::Rails::Engine
    isolate_namespace Calckit

    config.autoload_paths << root.join("lib")

    initializer "calckit.eager_load_calculators" do |app|
      app.config.to_prepare do
        if Calckit.configuration.auto_register
          calculators_path = ::Rails.root.join(Calckit.configuration.calculators_path)
          if calculators_path.exist?
            ::Rails.autoloaders.main.eager_load_dir(calculators_path)
          end
        end
      end
    end

    initializer "calckit.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include Calckit::ViewHelpers
      end
    end

    initializer "calckit.controller_helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        include Calckit::ControllerHelpers
      end
    end
  end
end

require_relative "rails/controller_helpers"
require_relative "rails/view_helpers"
require_relative "rails/model"
