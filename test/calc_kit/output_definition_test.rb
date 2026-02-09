# frozen_string_literal: true

require "test_helper"

class CalcKit::OutputDefinitionTest < Minitest::Test
  def test_basic_attributes
    output = CalcKit::OutputDefinition.new(:total, :decimal)
    assert_equal :total, output.name
    assert_equal :decimal, output.type
    assert_equal({}, output.options)
  end

  def test_label_from_options
    output = CalcKit::OutputDefinition.new(:total, :decimal, label: "Grand Total")
    assert_equal "Grand Total", output.label
  end

  def test_label_generated_from_name
    output = CalcKit::OutputDefinition.new(:grand_total, :decimal)
    assert_equal "Grand total", output.label
  end

  def test_format
    output = CalcKit::OutputDefinition.new(:total, :decimal, format: "%.2f")
    assert_equal "%.2f", output.format
  end

  def test_equality
    output1 = CalcKit::OutputDefinition.new(:total, :decimal)
    output2 = CalcKit::OutputDefinition.new(:total, :decimal)
    output3 = CalcKit::OutputDefinition.new(:total, :integer)

    assert_equal output1, output2
    refute_equal output1, output3
  end
end
