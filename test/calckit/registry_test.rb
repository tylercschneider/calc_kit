# frozen_string_literal: true

require "test_helper"

class Calckit::RegistryTest < Minitest::Test
  class TestCalculator < Calckit::Base
    calculator_name "Test"
    calculator_slug :test
    version "1.0"

    def calculate
      {}
    end
  end

  def setup
    @registry = Calckit::Registry.new
  end

  def test_register_and_find
    @registry.register(TestCalculator)
    assert_equal TestCalculator, @registry.find(:test)
  end

  def test_find_with_string
    @registry.register(TestCalculator)
    assert_equal TestCalculator, @registry.find("test")
  end

  def test_find_returns_nil_for_unknown
    assert_nil @registry.find(:unknown)
  end

  def test_all
    @registry.register(TestCalculator)
    assert_includes @registry.all, TestCalculator
  end

  def test_slugs
    @registry.register(TestCalculator)
    assert_includes @registry.slugs, :test
  end

  def test_clear
    @registry.register(TestCalculator)
    @registry.clear
    assert_empty @registry.all
  end

  def test_registered
    @registry.register(TestCalculator)
    assert @registry.registered?(:test)
    refute @registry.registered?(:unknown)
  end

  def test_raises_without_slug
    klass = Class.new(Calckit::Base) do
      calculator_name "No Slug"
      def calculate
        {}
      end
    end

    assert_raises(ArgumentError) do
      @registry.register(klass)
    end
  end
end
