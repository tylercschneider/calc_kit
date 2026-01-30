# frozen_string_literal: true

require "test_helper"

class Calckit::BaseTest < Minitest::Test
  class SimpleCalculator < Calckit::Base
    calculator_name "Simple Calculator"
    calculator_slug :simple
    version "1.0"

    input :value, :decimal, label: "Value", required: true, min: 0

    output :doubled, :decimal

    def calculate
      { doubled: value * 2 }
    end
  end

  def setup
    @calculator = SimpleCalculator.new
  end

  def test_calculator_name
    assert_equal "Simple Calculator", SimpleCalculator.calculator_name
  end

  def test_calculator_slug
    assert_equal :simple, SimpleCalculator.calculator_slug
  end

  def test_version
    assert_equal "1.0", SimpleCalculator.version
  end

  def test_inputs
    assert_equal 1, SimpleCalculator.inputs.size
    input = SimpleCalculator.inputs.first
    assert_equal :value, input.name
    assert_equal :decimal, input.type
    assert input.required?
  end

  def test_outputs
    assert_equal 1, SimpleCalculator.outputs.size
    output = SimpleCalculator.outputs.first
    assert_equal :doubled, output.name
    assert_equal :decimal, output.type
  end

  def test_input_for
    input = SimpleCalculator.input_for(:value)
    assert_equal :value, input.name
  end

  def test_validation_required
    assert_not @calculator.valid?
    assert_includes @calculator.errors[:value], "can't be blank"
  end

  def test_validation_min
    @calculator.value = -5
    assert_not @calculator.valid?
    assert_includes @calculator.errors[:value], "must be greater than or equal to 0"
  end

  def test_run_returns_nil_when_invalid
    assert_nil @calculator.run
  end

  def test_run_returns_result_when_valid
    @calculator.value = 5
    result = @calculator.run
    assert_equal({ doubled: 10 }, result)
  end

  def test_run_bang_raises_when_invalid
    assert_raises(ActiveModel::ValidationError) do
      @calculator.run!
    end
  end

  def test_run_bang_returns_result_when_valid
    @calculator.value = 5
    result = @calculator.run!
    assert_equal({ doubled: 10 }, result)
  end

  def test_input_values
    @calculator.value = 5
    assert_equal({ value: 5 }, @calculator.input_values)
  end

  def test_instance_methods
    @calculator.value = 5
    assert_equal "Simple Calculator", @calculator.calculator_name
    assert_equal :simple, @calculator.calculator_slug
    assert_equal "1.0", @calculator.version
  end

  private

  def assert_not(value, message = nil)
    assert !value, message
  end
end
