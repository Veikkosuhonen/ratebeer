class PlacesController < ApplicationController
  def index

  end

  def search
    api_key = "aa2f2cfcc83fda0745de9ea2e519065f"
    url = "http://beermapping.com/webservice/loccity/#{api_key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode params[:city]}"
    places_from_api = response.parsed_response["bmp_locations"]["location"]

    if places_from_api.is_a?(Hash)  && places_from_api["id"].nil?
      redirect_to places_path, notice: "No places in #{params[:city]}"
    else
      @places = places_from_api.map { |place|
        Place.new place
      }

      render :index, status: 418
    end
  end
end
