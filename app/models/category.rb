class Category < ApplicationRecord
  belongs_to :restaurant

  has_many :items, inverse_of: :category
  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true
end
