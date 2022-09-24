class RatingsController < ApplicationController
  include TopStatsHelper
  before_action :ensure_that_signed_in, except: [:index]

  before_action invalidate_cache(
    "all_beers_table-name",
    "all_beers_table-brewery",
    "all_beers_table-style",
    "active_breweries_table"
  ), only: [:create, :destroy]

  def index
    # Fetch expensive stats from cache. See app/helpers/top_stats_helper.rb
    # Cronjob app/jobs/refresh_stats_job.rb refreshes the cache every 10 minutes.
    # The job is started in config/application.rb on config.after_initialize
    stats = fetch_top_stats
    @top_beers = stats[:beers]
    @top_breweries = stats[:breweries]
    @top_users = stats[:users]
    @top_styles = stats[:styles]
    # Always query these from db because its fast (max 5 objects) and this way they are perfectly up to date
    @latest_ratings = Rating.recent
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
