# frozen_string_literal: true

module CalcKit
  class Engine < ::Rails::Engine
    isolate_namespace CalcKit

    config.autoload_paths << root.join("lib")

    initializer "calc_kit.eager_load_calculators" do |app|
      app.config.to_prepare do
        if CalcKit.configuration.auto_register
          calculators_path = ::Rails.root.join(CalcKit.configuration.calculators_path)
          if calculators_path.exist?
            ::Rails.autoloaders.main.eager_load_dir(calculators_path)
          end
        end
      end
    end

    initializer "calc_kit.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include CalcKit::ViewHelpers
      end
    end

    initializer "calc_kit.controller_helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        include CalcKit::ControllerHelpers
      end
    end
  end
end

require_relative "rails/controller_helpers"
require_relative "rails/view_helpers"
require_relative "rails/model"
