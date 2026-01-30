# frozen_string_literal: true

require "test_helper"

class Calckit::ConfigurationTest < Minitest::Test
  def setup
    @config = Calckit::Configuration.new
  end

  def test_default_calculators_path
    assert_equal "app/calculators", @config.calculators_path
  end

  def test_default_auto_register
    assert @config.auto_register
  end

  def test_default_scope_method
    assert_nil @config.scope_method
  end

  def test_default_enable_turbo_streams
    assert @config.enable_turbo_streams
  end

  def test_default_save_calculations
    assert @config.save_calculations
  end

  def test_default_warn_on_version_mismatch
    assert @config.warn_on_version_mismatch
  end

  def test_default_form_classes
    assert_equal "form-control", @config.default_form_classes[:input]
    assert @config.default_form_classes[:label]
    assert @config.default_form_classes[:error]
    assert @config.default_form_classes[:submit]
  end

  def test_setting_values
    @config.calculators_path = "lib/calculators"
    @config.scope_method = :current_user

    assert_equal "lib/calculators", @config.calculators_path
    assert_equal :current_user, @config.scope_method
  end
end
