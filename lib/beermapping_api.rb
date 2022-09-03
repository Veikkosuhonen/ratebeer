class BeermappingApi
  def self.places_in(city)
    Rails.cache.fetch(city.downcase) { get_places_in city }
  end

  def self.place_by_id(id)
    Rails.cache.fetch(id, expires_in: 1.hour) { get_place_by_id id }
  end

  def self.get_place_by_id(id)
    url = "http://beermapping.com/webservice/locquery/#{key}"

    response = HTTParty.get "#{url}/#{id}"
    place = response.parsed_response["bmp_locations"]["location"]

    if place.nil? || place[:id] == "0"
      return nil
    end

    Place.new place
  end

  def self.get_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) && places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do |placeData|
      place = Place.new(placeData)
      Rails.cache.write place.id, place, { expires_in: 10.minutes }
      place
    end
  end

  def self.key
    return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil
    raise 'BEERMAPPING_APIKEY env variable not defined' if ENV['BEERMAPPING_APIKEY'].nil?

    ENV.fetch('BEERMAPPING_APIKEY')
  end
end
