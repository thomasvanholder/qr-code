# require 'pry'

class Restaurant < ApplicationRecord
  include Rails.application.routes.url_helpers

  after_create :create_qr_code

  # avoid validation block because restaurant is not yet created
  has_many :categories, inverse_of: :restaurant
  has_many :notifications, as: :recipient

  # save only new restaurant if it has categories (all_blank)
  accepts_nested_attributes_for :categories, reject_if: :all_blank, allow_destroy: true

  has_one_attached :picture

  def create_qr_code
    qr = RQRCode::QRCode.new(restaurant_url(self))
    svg = qr.as_svg(
      offset: 0, # no padding
      color: "000", # color black
      shape_rendering: "crispEdges",
      module_size: 6, # all modules 6px each (size)
      standalone: true
    )
    self.qr_code = svg
    self.save
  end

  class << self
    def default_url_options
      Rails.application.config.action_mailer.default_url_options
    end
  end
end
