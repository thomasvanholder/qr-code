class Item < ApplicationRecord
  belongs_to :category
  # belongs_to :restaurant, through: :category

  has_one_attached :picture
end
