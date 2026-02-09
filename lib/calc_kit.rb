# frozen_string_literal: true

require_relative "calc_kit/version"
require_relative "calc_kit/configuration"
require_relative "calc_kit/input_definition"
require_relative "calc_kit/output_definition"
require_relative "calc_kit/dsl"
require_relative "calc_kit/registry"
require_relative "calc_kit/base"

module CalcKit
  class NotFoundError < StandardError; end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def registry
      @registry ||= Registry.new
    end

    def register(calculator_class)
      registry.register(calculator_class)
    end

    def find(slug)
      registry.find(slug)
    end

    def all
      registry.all
    end
  end
end

# Load Rails engine if Rails is present
require_relative "calc_kit/engine" if defined?(Rails::Engine)
