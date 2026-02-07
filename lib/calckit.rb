# frozen_string_literal: true

require_relative "calckit/version"
require_relative "calckit/configuration"
require_relative "calckit/input_definition"
require_relative "calckit/output_definition"
require_relative "calckit/dsl"
require_relative "calckit/registry"
require_relative "calckit/base"

module Calckit
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
require_relative "calckit/engine" if defined?(Rails::Engine)
