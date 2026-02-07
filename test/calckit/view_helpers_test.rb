# frozen_string_literal: true

require "test_helper"
require "calckit/rails/view_helpers"

class Calckit::ViewHelpersTest < Minitest::Test
  include Calckit::ViewHelpers

  def test_format_output_nil_value_returns_empty_string
    %i[integer decimal currency percentage date string].each do |type|
      assert_equal "", calckit_format_output(nil, type), "nil should return empty string for :#{type}"
    end
  end

  def test_format_output_integer
    assert_equal "42", calckit_format_output(42.7, :integer)
  end

  def test_format_output_decimal
    assert_equal "3.14", calckit_format_output(3.14159, :decimal)
  end

  def test_format_output_currency
    assert_equal "$9.99", calckit_format_output(9.99, :currency)
  end

  def test_format_output_percentage
    assert_equal "85.5%", calckit_format_output(85.5, :percentage)
  end

  def test_format_output_string
    assert_equal "hello", calckit_format_output("hello", :string)
  end

  def test_format_output_default_type
    assert_equal "anything", calckit_format_output("anything", :unknown)
  end

  def test_resolve_default_with_static_value
    assert_equal 42, calckit_resolve_default(42)
  end

  def test_resolve_default_with_proc
    assert_equal "computed", calckit_resolve_default(-> { "computed" })
  end
end
