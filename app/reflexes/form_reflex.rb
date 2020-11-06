# frozen_string_literal: true
require 'pry'

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
    id = extract_menu_id(element.name)
    morph "#item-name-#{id}", element.value
  end

  def print_price
    id = extract_menu_id(element.name)
    morph "#item-price-#{id}", "$#{element.value}"
  end

  def print_description
    id = extract_menu_id(element.name)
    morph "#item-description-#{id}", element.value
  end

  private

  def extract_id(string)
    # get 5 or more digits to match [1604647606030]
    return string.match(/\d{5,}/)[0]
  end

  def extract_menu_id(string)
    # get  5 or more digits to match [1604647606030] ending with [name], split after first ]
    return element.name.match(/[i][t][e][m][s].[a-z]{3,}\S\S\d{5,}/)[0].partition('[').last
  end
end
