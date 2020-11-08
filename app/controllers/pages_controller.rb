class PagesController < ApplicationController
  def home
    @restaurant = Restaurant.new
    @restaurant.categories.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)

    if @restaurant.save
      redirect_to @restaurant # , notice: "Project succesfully saved"
    else
      render :home
    end
  end

  private

  def restaurant_params
    # _destroy allows to delete categories from restaurant form
    params.require(:restaurant).permit(:name, :picture, categories_attributes: %i[id name _destroy])
  end
end
