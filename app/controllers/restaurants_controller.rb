require 'csv'

class RestaurantsController < ApplicationController
  before_action :find_restaurant, only: [:show,:edit, :update,:generator, :qrcode, :send_email_qr_code, ]

  def index
    @restaurant = Restaurant.first.deep_clone include: { categories: :items } do |original, copy|
      copy.picture.attach(original.picture.blob) if (copy.is_a?(Restaurant) || copy.is_a?(Item)) && original.picture.attached?
    end
  end

  def show
  end

  def new
    @restaurant = Restaurant.new
    @restaurant.categories.build.items.build
  end

  def qrcode
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurant_qrcode_url(@restaurant) , notice: { title: "QR Menu created", content: "Anyone with the QR code can now view this menu." }
    else
      render :new
    end
  end

  def generator
    @categories = @restaurant.categories
  end

  def edit
    @categories = @restaurant.categories
  end

  def update
    # if params [:restaurant][:picture] is not sent, call purge on existing active_storage
    if @restaurant.update(restaurant_params)
      @restaurant.picture.purge if !params[:restaurant]["picture"].present?
      # for every menu item check if picture is not present, call purge on existing active_storage
      # render :generator, notice: { title: "QR Menu updated", content: "Anyone with the QR code can now view this menu." }
    else
      render :edit
    end
  end

  def send_email_qr_code
    @restaurant.update(email: params[:email])
    if @restaurant.save
    # send email with QR Code and edit link
      QrcodeMailer.with(restaurant: @restaurant).send_qr_code_email.deliver_now
      redirect_to restaurant_qrcode_url(@restaurant), notice: { title: "Email sent with QR Code", content: "Use email link to edit your QR Menu" }
    else
      render :qrcode
    end
  end

  def purge_item_picture
  # check if id exist
    menu_id = params.keys.first.to_i
    item = Item.find(menu_id)
    item.picture.purge
  end

  private

  def find_restaurant
    @restaurant = Restaurant.friendly.find(params[:id])
  end

  def restaurant_params
    # _destroy allows to delete categories from restaurant form
    params.require(:restaurant).permit(
      :name,
      :picture,
      :qr_code_png,
      # item attributes are nested inside each category
      categories_attributes: [:id, :name, :_destroy, items_attributes: [:id, :name ,:price ,:description, :picture, :_destroy]])
  end
end
