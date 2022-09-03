class UnsplashApi
  def self.random
    get_random_photo
  end

  def self.get_random_photo
    return nil if Rails.env != "production"

    Unsplash.configure do |config|
      config.application_access_key = "4I7ILH3oTFHYc0yRSwOcYpjGpArzIonEmHBtzG71aKk"
      config.application_secret = "?"
      config.application_redirect_uri = "https://reitbiir.fly.dev"
      config.utm_source = "reitbiir"
    end

    photo = Unsplash::Photo.random(count: 1).first
    photo.urls[:regular]
  end
end
