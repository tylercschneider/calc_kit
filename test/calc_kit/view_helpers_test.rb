# frozen_string_literal: true

require "test_helper"
require "calc_kit/rails/view_helpers"

class CalcKit::ViewHelpersTest < Minitest::Test
  include CalcKit::ViewHelpers

  def test_format_output_nil_value_returns_empty_string
    %i[integer decimal currency percentage date string].each do |type|
      assert_equal "", calc_kit_format_output(nil, type), "nil should return empty string for :#{type}"
    end
  end

  def test_format_output_integer
    assert_equal "42", calc_kit_format_output(42.7, :integer)
  end

  def test_format_output_decimal
    assert_equal "3.14", calc_kit_format_output(3.14159, :decimal)
  end

  def test_format_output_currency
    assert_equal "$9.99", calc_kit_format_output(9.99, :currency)
  end

  def test_format_output_percentage
    assert_equal "85.5%", calc_kit_format_output(85.5, :percentage)
  end

  def test_format_output_string
    assert_equal "hello", calc_kit_format_output("hello", :string)
  end

  def test_format_output_default_type
    assert_equal "anything", calc_kit_format_output("anything", :unknown)
  end

  def test_resolve_default_with_static_value
    assert_equal 42, calc_kit_resolve_default(42)
  end

  def test_resolve_default_with_proc
    assert_equal "computed", calc_kit_resolve_default(-> { "computed" })
  end

  # calc_kit_version_warning tests

  def test_version_warning_returns_nil_when_versions_match
    calculation = stub_calculation(version_mismatch: false)
    assert_nil calc_kit_version_warning(calculation)
  end

  def test_version_warning_returns_string_when_versions_differ
    calculation = stub_calculation(version_mismatch: true)
    result = calc_kit_version_warning(calculation)
    assert_kind_of String, result
    assert_includes result, "version"
  end

  def test_version_warning_returns_nil_when_config_disabled
    calculation = stub_calculation(version_mismatch: true)
    CalcKit.configuration.warn_on_version_mismatch = false
    assert_nil calc_kit_version_warning(calculation)
  ensure
    CalcKit.configuration.warn_on_version_mismatch = true
  end

  private

  def stub_calculation(version_mismatch:)
    calc = Minitest::Mock.new
    calc.expect(:version_mismatch?, version_mismatch)
    calc
  end
end
