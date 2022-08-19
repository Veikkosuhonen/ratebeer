class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user
    if @rating.save
      redirect_to current_user
    else
      @beers = Beer.all
      render :new, status: 422
    end
  end

  def destroy
    Rating.destroy(params[:id])
    redirect_to ratings_path
  end
end
