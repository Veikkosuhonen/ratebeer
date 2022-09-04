class WeatherApi
  def self.weather_in(city)
    Rails.cache.fetch("weather:#{city}", { expires_in: 10.minutes }) { fetch_weather_in city }
  end

  def self.fetch_weather_in(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}"

    response = HTTParty.get "#{url}&query=#{ERB::Util.url_encode(city)}"
    weather = response.parsed_response["current"]

    if weather.nil?
      return nil
    end

    Weather.new weather
  end

  def self.key
    return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil
    raise 'WEATHERSTACK_APIKEY env variable not defined' if ENV['WEATHERSTACK_APIKEY'].nil?

    ENV.fetch('WEATHERSTACK_APIKEY')
  end
end
