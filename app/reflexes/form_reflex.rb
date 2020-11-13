# frozen_string_literal: true
# Any declared instance variables will be made available to the Rails controller and view.
class FormReflex < ApplicationReflex
  def print_restaurant
    morph "#restaurant-name", element.value
  end

  def print_category
    id = extract_id(element.name)
    morph "#category-#{id}", element.value
    morph "#tab-#{id}", element.value
  end

  def print_item
    id = element.dataset.item
    morph "#item-name-#{id}", element.value
  end

  def print_price
    id = element.dataset.item
    morph "#item-price-#{id}", "$#{element.value}"
  end

  def print_description
    id = element.dataset.item
    morph "#item-description-#{id}", element.value
  end

  private

  def extract_id(string)
    # get 5 or more digits to match [1604647606030]
    string.match(/\d{1,}/)[0]
  end
end

