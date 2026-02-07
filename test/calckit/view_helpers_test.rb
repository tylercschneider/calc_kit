# frozen_string_literal: true

require "test_helper"
require "calckit/rails/view_helpers"

class Calckit::ViewHelpersTest < Minitest::Test
  include Calckit::ViewHelpers

  def test_format_output_nil_value_returns_empty_string
    assert_equal "", calckit_format_output(nil, :integer)
  end
end
