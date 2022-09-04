class PlacesController < ApplicationController
  def index
  end

  def show
    @place = BeermappingApi.place_by_id params[:id]
    @weather = WeatherApi.weather_in @place.city
    render :show
  end

  def search
    @places = BeermappingApi.places_in params[:city]
    @weather = WeatherApi.weather_in params[:city]

    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:city] = params[:city]
      render :index, status: 418
    end
  end
end
