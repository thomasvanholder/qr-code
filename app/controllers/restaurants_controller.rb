# require 'pry'

class RestaurantsController < ApplicationController
  def index
    @restaurant = Restaurant.first # sample restaurant

    instance = RQRCode::QRCode.new(restaurant_url(@restaurant))
    @svg = generate_qr_code(instance)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new
    @restaurant = Restaurant.new
    @restaurant.categories.build.items.build
  end

  def qrcode
    @restaurant = Restaurant.find(params[:id])
    instance = RQRCode::QRCode.new(restaurant_url(@restaurant))
    @svg = generate_qr_code(instance)
  end

  def generate_qr_code(instance)
    instance.as_svg(
    offset: 0, # no padding
      color: "000", # color black
      shape_rendering: "crispEdges",
      module_size: 6, # all modules 6px each (size)
      standalone: true
    )
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurant_qrcode_url(@restaurant), notice: { title: "QR Menu created", content: "Anyone with the QR code can now view this menu." }
    else
      render :home
    end
  end

  def edit
  end

  def send_email_qr_code
    @restaurant = Restaurant.find(params[:id].to_i)
    @restaurant.update(email: params[:email])
    if @restaurant.save
      # send email with QR Code and edit link
      QrcodeMailer.with(restaurant: @restaurant).send_qr_code_email.deliver_now
      redirect_to restaurant_qrcode_url(@restaurant), notice: { title: "Email sent with QR Code", content: "Use email link to edit your QR Menu" }
    else
      render :qrcode
    end
  end

  private

  def restaurant_params
    # _destroy allows to delete categories from restaurant form
    params.require(:restaurant).permit(
      :name,
      :picture,
      # item attributes are nested inside each category
      categories_attributes: [:id, :name, :_destroy, { items_attributes: %i[id name price description picture _destroy] }]
    )
  end
end
