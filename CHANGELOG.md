# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-06-01

### Added

- Declarative DSL for defining calculator inputs and outputs
- Input types: string, integer, decimal, date, select, boolean
- Output types: string, integer, decimal, date, currency, percentage
- ActiveModel validations (required, min, max)
- Calculator registry for lookup by slug
- Rails engine with controller helpers and view helpers
- Generators for install, calculator scaffolding
- Optional persistence via Calculation model concern
