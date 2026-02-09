# frozen_string_literal: true

require "test_helper"
require "calc_kit/rails/model"

class CalcKit::ModelTest < Minitest::Test
  class VersionedCalculator < CalcKit::Base
    calculator_name "Versioned Calculator"
    calculator_slug :versioned
    version "2.0"

    input :value, :decimal, label: "Value", required: true

    output :result, :decimal

    def calculate
      { result: value }
    end
  end

  # Minimal model stub that includes the Model concern
  class FakeCalculation
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :calculator_type, :string
    attribute :calculator_version, :string
    attribute :inputs
    attribute :outputs

    include CalcKit::Model
  end

  def setup
    CalcKit.registry.clear
    CalcKit.register(VersionedCalculator)
  end

  def test_version_current_returns_true_when_versions_match
    calculation = FakeCalculation.new(
      calculator_type: "versioned",
      calculator_version: "2.0",
      inputs: { value: 1 },
      outputs: { result: 1 }
    )

    assert calculation.version_current?
  end

  def test_version_current_returns_false_when_versions_differ
    calculation = FakeCalculation.new(
      calculator_type: "versioned",
      calculator_version: "1.0",
      inputs: { value: 1 },
      outputs: { result: 1 }
    )

    refute calculation.version_current?
  end

  def test_version_mismatch_returns_true_when_versions_differ
    calculation = FakeCalculation.new(
      calculator_type: "versioned",
      calculator_version: "1.0",
      inputs: { value: 1 },
      outputs: { result: 1 }
    )

    assert calculation.version_mismatch?
  end

  def test_version_mismatch_returns_false_when_versions_match
    calculation = FakeCalculation.new(
      calculator_type: "versioned",
      calculator_version: "2.0",
      inputs: { value: 1 },
      outputs: { result: 1 }
    )

    refute calculation.version_mismatch?
  end

  def test_version_current_returns_false_when_calculator_not_found
    calculation = FakeCalculation.new(
      calculator_type: "nonexistent",
      calculator_version: "1.0",
      inputs: { value: 1 },
      outputs: { result: 1 }
    )

    refute calculation.version_current?
    assert calculation.version_mismatch?
  end

  def test_calculator_class_returns_registered_class
    calculation = FakeCalculation.new(
      calculator_type: "versioned",
      calculator_version: "2.0",
      inputs: { value: 1 },
      outputs: { result: 1 }
    )

    assert_equal VersionedCalculator, calculation.calculator_class
  end

  def test_to_calculator_returns_populated_instance
    calculation = FakeCalculation.new(
      calculator_type: "versioned",
      calculator_version: "2.0",
      inputs: { "value" => "5.0" },
      outputs: { result: 5.0 }
    )

    calc = calculation.to_calculator
    assert_instance_of VersionedCalculator, calc
    assert_equal 5.0, calc.value
  end
end
