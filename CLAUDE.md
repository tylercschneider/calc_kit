# CLAUDE.md

This file provides guidance to Claude Code when working with this gem.

## Overview

CalcKit is a Ruby gem providing a declarative DSL for building calculators with automatic form generation, validation, and optional persistence. Works standalone with ActiveModel or as a Rails engine.

## Quick Start for Host Apps

### Installation

```ruby
# Gemfile
gem "calc_kit", github: "tylercschneider/calc_kit"
```

Then run the install generator:

```bash
rails g calc_kit:install --model --scope=current_account
```

This creates:
- `config/initializers/calc_kit.rb` - Configuration
- `app/calculators/application_calculator.rb` - Base class
- `app/models/calculation.rb` - Persistence model (with --model)
- Migration for calculations table

### Creating a Calculator

```bash
rails g calc_kit:calculator shipping
```

Then edit `app/calculators/shipping_calculator.rb`:

```ruby
class ShippingCalculator < ApplicationCalculator
  calculator_name "Shipping Calculator"
  calculator_slug :shipping
  version "1.0"

  input :weight, :decimal, label: "Weight (lbs)", required: true, min: 0.1
  input :zone, :select, label: "Zone", required: true, options: [["Zone 1", "1"], ["Zone 2", "2"]]

  output :cost, :currency
  output :delivery_days, :integer

  def calculate
    base = weight * 0.50
    zone_multiplier = zone == "2" ? 1.5 : 1.0
    {
      cost: base * zone_multiplier,
      delivery_days: zone == "2" ? 5 : 3
    }
  end
end

CalcKit.register(ShippingCalculator)
```

### Input Types

| Type | Renders As | Options |
|------|-----------|---------|
| `:string` | text field | `placeholder` |
| `:integer` | number field | `min`, `max`, `step` |
| `:decimal` | number field | `min`, `max`, `step` (default 0.01) |
| `:date` | date picker | `default` (can be proc) |
| `:select` | dropdown | `options` (array of [label, value]) |
| `:boolean` | checkbox | |

### Input Options

```ruby
input :name, :type,
  label: "Display Label",      # Form label text
  required: true,              # Adds presence validation
  min: 0,                      # Minimum value (numeric types)
  max: 100,                    # Maximum value (numeric types)
  step: 0.01,                  # Step increment (decimal)
  default: 10,                 # Default value (can be a proc: -> { Date.current })
  placeholder: "Enter value",  # Placeholder text
  hint: "Help text",           # Help text below input
  options: [["Label", "val"]]  # For :select type
```

### Output Types

| Type | Formatting |
|------|-----------|
| `:string` | As-is |
| `:integer` | Whole number |
| `:decimal` | 2 decimal places |
| `:date` | Long date format |
| `:currency` | $X.XX |
| `:percentage` | X.X% |

### Controller Pattern

```ruby
class CalculatorsController < ApplicationController
  def show
    @calculator_class = CalcKit.find(params[:slug])
    @calculator = @calculator_class.new(calculator_params)
  end

  def create
    @calculator_class = CalcKit.find(params[:slug])
    @calculator = @calculator_class.new(calculator_params)
    @result = @calculator.run
    # ...
  end

  private

  def calculator_params
    return {} unless params[:calculator]
    params.require(:calculator).permit(*@calculator_class.inputs.map(&:name))
  end
end
```

### Key APIs

```ruby
# Registry
CalcKit.find(:slug)           # Find calculator by slug
CalcKit.all                   # All registered calculators
CalcKit.register(MyCalc)      # Register a calculator

# Calculator class methods
MyCalculator.calculator_name  # "My Calculator"
MyCalculator.calculator_slug  # :my_calculator
MyCalculator.version          # "1.0"
MyCalculator.inputs           # Array of InputDefinition
MyCalculator.outputs          # Array of OutputDefinition
MyCalculator.input_for(:name) # Find specific input

# Calculator instance methods
calc = MyCalculator.new(price: 10)
calc.valid?                   # Run validations
calc.run                      # Returns result hash or nil if invalid
calc.run!                     # Returns result hash or raises ValidationError
calc.input_values             # Hash of current input values
```

## Gem Development

### Running Tests

```bash
bundle exec rake test
```

### File Structure

```
lib/calc_kit/
├── base.rb              # Calculator base class
├── dsl.rb               # DSL macros (input, output, version)
├── registry.rb          # Calculator lookup
├── input_definition.rb  # Input field metadata
├── output_definition.rb # Output field metadata
├── configuration.rb     # Config options
├── engine.rb            # Rails engine
└── rails/
    ├── controller_helpers.rb
    ├── view_helpers.rb
    └── model.rb         # Calculation model concern
```

### Adding a New Input Type

1. Add type mapping in `lib/calc_kit/dsl.rb` `type_for_attribute` method
2. Add rendering logic in generator view templates
3. Add formatting in `lib/calc_kit/rails/view_helpers.rb` if needed
4. Add tests

### Adding a New Output Type

1. Add formatting in `lib/calc_kit/rails/view_helpers.rb` `calc_kit_format_output` method
2. Add tests
