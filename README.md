# CalcKit

A Ruby gem providing a declarative DSL for building calculators with automatic form generation, validation, and optional persistence. Works standalone with ActiveModel or as a Rails engine.

## Installation

Add to your Gemfile:

```ruby
gem "calc_kit"
```

Then run the install generator:

```bash
rails g calc_kit:install
```

Options:
- `--model` - Generate a Calculation model for persistence
- `--views` - Copy default views to your app
- `--scope=current_account` - Configure multi-tenancy scope

## Usage

### Defining a Calculator

```ruby
# app/calculators/price_calculator.rb
class PriceCalculator < ApplicationCalculator
  calculator_name "Price Calculator"
  calculator_slug :price
  version "1.0"

  input :price, :decimal, label: "Unit Price", required: true, min: 0.01
  input :quantity, :integer, label: "Quantity", required: true, min: 1
  input :discount, :decimal, label: "Discount %", default: 0, min: 0, max: 100

  output :subtotal, :decimal
  output :total, :decimal

  def calculate
    sub = price * quantity
    disc = sub * (discount / 100.0)
    {
      subtotal: sub,
      total: sub - disc
    }
  end
end

CalcKit.register(PriceCalculator)
```

### Input Types

- `:string` - Text input
- `:integer` - Whole number input
- `:decimal` - Decimal number input
- `:date` - Date picker
- `:select` - Dropdown (use `options:` to provide choices)
- `:boolean` - Checkbox

### Input Options

```ruby
input :name, :type,
  label: "Display Label",      # Form label
  required: true,              # Adds presence validation
  min: 0,                      # Minimum value (numeric)
  max: 100,                    # Maximum value (numeric)
  step: 0.01,                  # Step increment (decimal)
  default: 10,                 # Default value (can be a proc)
  placeholder: "Enter value",  # Placeholder text
  hint: "Help text",           # Help text below input
  options: [["Label", "value"], ...] # For :select type
```

### Output Types

- `:string` - Plain text
- `:integer` - Formatted integer
- `:decimal` - Formatted decimal (2 places)
- `:date` - Formatted date
- `:currency` - Currency formatted
- `:percentage` - Percentage formatted

### Running Calculations

```ruby
calc = PriceCalculator.new(price: 10, quantity: 5, discount: 10)

if calc.valid?
  result = calc.run
  # => { subtotal: 50.0, total: 45.0 }
end

# Or use run! to raise on validation errors
result = calc.run!
```

### Controller Integration

```ruby
class CalculatorsController < ApplicationController
  include CalcKit::ControllerHelpers

  def show
    @calculator_class = find_calculator_class(params[:slug])
    @calculator = build_calculator(@calculator_class)
    @saved_calculations = load_saved_calculations(@calculator_class)
  end

  def create
    @calculator_class = find_calculator_class(params[:slug])
    @calculator = build_calculator(@calculator_class)
    @result = @calculator.run

    if @result
      save_calculation(@calculator, @result) if params[:save].present?
      # ...
    end
  end
end
```

### View Helpers

```erb
<%# Resolve callable defaults %>
<%= calc_kit_resolve_default(input.default) %>

<%# Format output values %>
<%= calc_kit_format_output(result[:total], :currency) %>

<%# CSS classes %>
<%= calc_kit_input_class(calculator, input) %>
<%= calc_kit_label_class %>
<%= calc_kit_error_class %>
```

## Configuration

```ruby
# config/initializers/calc_kit.rb
CalcKit.configure do |config|
  # Path to calculator classes
  config.calculators_path = "app/calculators"

  # Auto-register calculators on load
  config.auto_register = true

  # Multi-tenancy scope method
  config.scope_method = :current_account

  # Enable Turbo Streams
  config.enable_turbo_streams = true

  # Enable calculation persistence
  config.save_calculations = true

  # Default CSS classes
  config.default_form_classes = {
    input: "form-control",
    label: "block text-sm font-medium mb-1",
    error: "text-red-500 text-sm mt-1",
    submit: "btn btn-primary"
  }
end
```

## Generators

```bash
# Install calc_kit
rails g calc_kit:install

# Generate a new calculator
rails g calc_kit:calculator shipping
```

## Roadmap

Potential future enhancements:

### Input Enhancements
- [ ] Input groups for organizing related fields
- [ ] Conditional inputs (show/hide based on other values)
- [ ] Custom validators beyond min/max
- [ ] More types: `:textarea`, `:radio`, `:checkbox_group`, `:range`

### Output Enhancements
- [ ] Custom formatters
- [ ] Conditional outputs (only show if value present)
- [ ] Output groups/sections

### Calculator Features
- [ ] Calculator descriptions for index pages
- [ ] Categories/tags for organizing calculators
- [ ] Comparison mode (side-by-side with different inputs)
- [ ] Calculator dependencies (one calculator feeds into another)

### Export & Sharing
- [ ] PDF export of results
- [ ] CSV export for saved calculations
- [ ] Shareable result links
- [ ] Embeddable calculator widgets

### Developer Experience
- [ ] Controller scaffold generator
- [ ] API endpoint generator
- [ ] JavaScript client for real-time calculation preview
- [ ] Form builder integration (SimpleForm, Formtastic)

### Testing
- [ ] Calculator test helpers
- [ ] Shared examples for common patterns

## License

MIT License
