# frozen_string_literal: true

module CalcKit
  class Configuration
    attr_accessor :calculators_path,
                  :auto_register,
                  :scope_method,
                  :enable_turbo_streams,
                  :save_calculations,
                  :warn_on_version_mismatch,
                  :default_form_classes

    def initialize
      @calculators_path = "app/calculators"
      @auto_register = true
      @scope_method = nil
      @enable_turbo_streams = true
      @save_calculations = true
      @warn_on_version_mismatch = true
      @default_form_classes = {
        input: "form-control",
        label: "block text-sm font-medium mb-1",
        error: "text-red-500 text-sm mt-1",
        submit: "btn btn-primary"
      }
    end
  end
end
