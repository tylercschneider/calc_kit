# Calckit

A Ruby gem providing a declarative DSL for building calculators with automatic form generation, validation, and optional persistence. Works standalone with ActiveModel or as a Rails engine.

## Installation

Add to your Gemfile:

```ruby
gem "calckit"
```

Then run the install generator:

```bash
rails g calckit:install
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

Calckit.register(PriceCalculator)
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
  include Calckit::ControllerHelpers

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
<%= calckit_resolve_default(input.default) %>

<%# Format output values %>
<%= calckit_format_output(result[:total], :currency) %>

<%# CSS classes %>
<%= calckit_input_class(calculator, input) %>
<%= calckit_label_class %>
<%= calckit_error_class %>
```

## Configuration

```ruby
# config/initializers/calckit.rb
Calckit.configure do |config|
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
# Install calckit
rails g calckit:install

# Generate a new calculator
rails g calckit:calculator shipping
```

## License

MIT License
