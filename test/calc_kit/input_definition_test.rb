# frozen_string_literal: true

require "test_helper"

class CalcKit::InputDefinitionTest < Minitest::Test
  def test_basic_attributes
    input = CalcKit::InputDefinition.new(:price, :decimal)
    assert_equal :price, input.name
    assert_equal :decimal, input.type
    assert_equal({}, input.options)
  end

  def test_label_from_options
    input = CalcKit::InputDefinition.new(:price, :decimal, label: "Unit Price")
    assert_equal "Unit Price", input.label
  end

  def test_label_generated_from_name
    input = CalcKit::InputDefinition.new(:unit_price, :decimal)
    assert_equal "Unit price", input.label
  end

  def test_required
    required = CalcKit::InputDefinition.new(:price, :decimal, required: true)
    optional = CalcKit::InputDefinition.new(:price, :decimal, required: false)
    default = CalcKit::InputDefinition.new(:price, :decimal)

    assert required.required?
    refute optional.required?
    refute default.required?
  end

  def test_default
    input = CalcKit::InputDefinition.new(:price, :decimal, default: 10.0)
    assert_equal 10.0, input.default
  end

  def test_placeholder
    input = CalcKit::InputDefinition.new(:price, :decimal, placeholder: "Enter price")
    assert_equal "Enter price", input.placeholder
  end

  def test_min_max
    input = CalcKit::InputDefinition.new(:price, :decimal, min: 0, max: 100)
    assert_equal 0, input.min
    assert_equal 100, input.max
  end

  def test_step
    input = CalcKit::InputDefinition.new(:price, :decimal, step: 0.01)
    assert_equal 0.01, input.step
  end

  def test_options_for_select
    options = [["Small", "s"], ["Large", "l"]]
    input = CalcKit::InputDefinition.new(:size, :select, options: options)
    assert_equal options, input.options_for_select
  end

  def test_hint
    input = CalcKit::InputDefinition.new(:price, :decimal, hint: "Enter in USD")
    assert_equal "Enter in USD", input.hint
  end

  def test_equality
    input1 = CalcKit::InputDefinition.new(:price, :decimal, min: 0)
    input2 = CalcKit::InputDefinition.new(:price, :decimal, min: 0)
    input3 = CalcKit::InputDefinition.new(:price, :integer, min: 0)

    assert_equal input1, input2
    refute_equal input1, input3
  end
end
