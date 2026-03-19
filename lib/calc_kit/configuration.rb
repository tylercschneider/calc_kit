# frozen_string_literal: true

module CalcKit
  class Configuration
    attr_accessor :calculators_path,
                  :auto_register,
                  :scope_method,
                  :enable_turbo_streams,
                  :save_calculations,
                  :warn_on_version_mismatch

    def initialize
      @calculators_path = "app/calculators"
      @auto_register = true
      @scope_method = nil
      @enable_turbo_streams = true
      @save_calculations = true
      @warn_on_version_mismatch = true
    end
  end
end
