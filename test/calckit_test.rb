# frozen_string_literal: true

require "test_helper"

class CalckitTest < Minitest::Test
  class ModuleTestCalculator < Calckit::Base
    calculator_name "Module Test"
    calculator_slug :module_test
    version "1.0"

    def calculate
      {}
    end
  end

  def setup
    Calckit.registry.clear
  end

  def test_version
    refute_nil Calckit::VERSION
  end

  def test_configuration
    assert_instance_of Calckit::Configuration, Calckit.configuration
  end

  def test_configure_block
    Calckit.configure do |config|
      config.calculators_path = "custom/path"
    end

    assert_equal "custom/path", Calckit.configuration.calculators_path

    # Reset
    Calckit.configuration.calculators_path = "app/calculators"
  end

  def test_register
    Calckit.register(ModuleTestCalculator)
    assert Calckit.registry.registered?(:module_test)
  end

  def test_find
    Calckit.register(ModuleTestCalculator)
    assert_equal ModuleTestCalculator, Calckit.find(:module_test)
  end

  def test_all
    Calckit.register(ModuleTestCalculator)
    assert_includes Calckit.all, ModuleTestCalculator
  end
end
