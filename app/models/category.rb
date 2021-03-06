class Category < ApplicationRecord
  belongs_to :restaurant

  has_many :items, -> { order(:id) }, inverse_of: :category, dependent: :destroy
  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  # validates :name, presence: true

end
