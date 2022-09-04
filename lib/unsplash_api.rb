class UnsplashApi
  def self.random
    fetch_random_photo
  end

  def self.fetch_random_photo
    return nil if Rails.env != "production"

    Unsplash.configure do |config|
      config.application_access_key = key
      config.application_secret = "?"
      config.application_redirect_uri = "https://reitbiir.fly.dev"
      config.utm_source = "reitbiir"
    end

    photo = Unsplash::Photo.random(count: 1).first
    photo.urls[:regular]
  end

  def self.key
    return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil
    raise 'UNSPLASH_ACCESS_KEY env variable not defined' if ENV['UNSPLASH_ACCESS_KEY'].nil?

    ENV.fetch('UNSPLASH_ACCESS_KEY')
  end
end
