# frozen_string_literal: true
# Any declared instance variables will be made available to the Rails controller and view.
class FormReflex < ApplicationReflex
  def print_restaurant
    morph "#restaurant-name", element.value
  end

  def print_category
    id = element.dataset.category_id || extract_id(element.name)
    morph "#category-#{id}", element.value
    morph "#tab-#{id}", element.value
  end

  def print_item
    id = element.dataset.item || extract_menu_id(element.name)
    morph "#item-name-#{id}", element.value
  end

  def print_price
    id = element.dataset.item || extract_menu_id(element.name)
    morph "#item-price-#{id}", "€#{element.value}"
  end

  def print_description
    id = element.dataset.item || extract_menu_id(element.name)
    morph "#item-description-#{id}", element.value
  end

  private

  def extract_id(string)
    # get 5 or more digits to match [1604647606030]
    string.match(/\d{1,}/)[0]
  end



  def extract_menu_id(string)
    sol = string.match(/items_attributes\S\S\d{1,}/)[0]
    sol.scan(/\d+/).first
  end
end



