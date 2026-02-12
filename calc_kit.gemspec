# frozen_string_literal: true

require_relative "lib/calc_kit/version"

Gem::Specification.new do |spec|
  spec.name = "calc_kit"
  spec.version = CalcKit::VERSION
  spec.authors = ["Tyler Schneider"]
  spec.email = ["tylercschneider@gmail.com"]

  spec.summary = "A DSL for building calculators with automatic form generation"
  spec.description = "CalcKit provides a declarative DSL for defining calculators with inputs, outputs, validation, and optional persistence. Works standalone or as a Rails engine."
  spec.homepage = "https://github.com/tylercschneider/calc_kit"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor docs/ Gemfile CLAUDE.md])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", ">= 7.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "railties", ">= 7.0"
end
