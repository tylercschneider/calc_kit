# frozen_string_literal: true

require "test_helper"
require "calckit/rails/controller_helpers"

class Calckit::ControllerHelpersTest < Minitest::Test
  # Minimal controller stub to include the concern
  class FakeController
    include Calckit::ControllerHelpers
    public :find_calculator_class
  end

  def setup
    @controller = FakeController.new
  end

  def test_find_calculator_class_raises_for_unknown_slug
    error = assert_raises(Calckit::NotFoundError) do
      @controller.find_calculator_class(:nonexistent)
    end
    assert_match(/nonexistent/, error.message)
  end
end
