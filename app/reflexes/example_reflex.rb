# frozen_string_literal: true
require 'pry'

class ExampleReflex < ApplicationReflex
  # Add Reflex methods in this file.
  #
  # All Reflex instances expose the following properties:
  #
  #   - connection - the ActionCable connection
  #   - channel - the ActionCable channel
  #   - request - an ActionDispatch::Request proxy for the socket connection
  #   - session - the ActionDispatch::Session store for the current visitor
  #   - url - the URL of the page that triggered the reflex
  #   - element - a Hash like object that represents the HTML element that triggered the reflex
  #   - params - parameters from the element's closest form (if any)
  #
  # Example:
  #
  #   def example(argument=true)
  #     # Your logic here...
  #     # Any declared instance variables will be made available to the Rails controller and view.
  #   end
  #
  # Learn more at: https://docs.stimulusreflex.com
  def toggle
    @count = element.dataset[:count].to_i + element.dataset[:step].to_i
  end

  def add_category
    # binding.pry
    counter = element.dataset[:category_count].to_i
    @category_count = counter.zero? ? 2 : counter + 1
    render(CategoryComponent.new(data: { wrapper_id: @category_count, input_id: @category_count, delete_id: @category_count }))
  end

  def type_category
    @category_name = element.value
  end
end
