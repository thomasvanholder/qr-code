class Item < ApplicationRecord
  belongs_to :category
  belongs_to :restaurant

  has_one_attached :picture
end
