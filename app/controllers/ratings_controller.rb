class RatingsController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index]

  before_action invalidate_cache(
                  "all_beers_table-name",
                  "all_beers_table-brewery",
                  "all_beers_table-style",
                  "active_breweries_table"
                ), only: [:create, :destroy]

  def index
    @top_beers = Beer.top 3
    @top_breweries = Brewery.top 3
    @latest_ratings = Rating.recent
    @top_users = User.top 3
    @top_styles = Style.top 3
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
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
