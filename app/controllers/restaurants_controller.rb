# require 'pry'

class RestaurantsController < ApplicationController
  def index
    @restaurant = Restaurant.new
    @restaurant.categories.build.items.build
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to edit_restaurant_url(@restaurant) #, notice: "Project succesfully saved"
    else
      render :home
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
   show_page_url = request.base_url + request.path
    qrcode = RQRCode::QRCode.new(show_page_url)
    @svg = qrcode.as_svg(
      offset: 0, # no padding
      color: '000', # color black
      shape_rendering: 'crispEdges',
      module_size: 6, # all modules 6px each (size)
      standalone: true
    )
  end

  private

  def restaurant_params
    # _destroy allows to delete categories from restaurant form
    params.require(:restaurant).permit(
      :name,
      :picture,
      # item attributes are nested inside each category
      categories_attributes: [:id, :name, :_destroy , items_attributes: [:id, :name, :price, :description, :picture, :_destroy]]
      )
  end
end
