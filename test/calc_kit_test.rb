# frozen_string_literal: true

require "test_helper"

class CalcKitTest < Minitest::Test
  class ModuleTestCalculator < CalcKit::Base
    calculator_name "Module Test"
    calculator_slug :module_test
    version "1.0"

    def calculate
      {}
    end
  end

  def setup
    CalcKit.registry.clear
  end

  def test_version
    refute_nil CalcKit::VERSION
  end

  def test_configuration
    assert_instance_of CalcKit::Configuration, CalcKit.configuration
  end

  def test_configure_block
    CalcKit.configure do |config|
      config.calculators_path = "custom/path"
    end

    assert_equal "custom/path", CalcKit.configuration.calculators_path

    # Reset
    CalcKit.configuration.calculators_path = "app/calculators"
  end

  def test_register
    CalcKit.register(ModuleTestCalculator)
    assert CalcKit.registry.registered?(:module_test)
  end

  def test_find
    CalcKit.register(ModuleTestCalculator)
    assert_equal ModuleTestCalculator, CalcKit.find(:module_test)
  end

  def test_all
    CalcKit.register(ModuleTestCalculator)
    assert_includes CalcKit.all, ModuleTestCalculator
  end
end
