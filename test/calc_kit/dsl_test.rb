# frozen_string_literal: true

require "test_helper"

class CalcKit::DSLTest < Minitest::Test
  def test_unknown_input_type_raises
    assert_raises(ArgumentError) do
      Class.new(CalcKit::Base) do
        calculator_name "Bad"
        calculator_slug :bad
        input :age, :integr
      end
    end
  end
end
