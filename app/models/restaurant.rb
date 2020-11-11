class Restaurant < ApplicationRecord
  # avoid validation block because restaurant is not yet created
  has_many :categories, inverse_of: :restaurant
  has_many :notifications, as: :recipient

  # save only new restaurant if it has categories (all_blank)
  accepts_nested_attributes_for :categories, reject_if: :all_blank, allow_destroy: true

  has_one_attached :picture
end

