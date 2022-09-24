module TopStatsHelper
  def fetch_top_stats
    unless Rails.cache.exist? "top-beers"
      cache_top_stats
    end

    {
      beers: Rails.cache.read("top-beers"),
      breweries: Rails.cache.read("top-breweries"),
      users: Rails.cache.read("top-users"),
      styles: Rails.cache.read("top-styles")
    }
  end

  def cache_top_stats
    expire_fragment "ratings_overview"
    Rails.cache.write "top-beers", Beer.top(3)
    Rails.cache.write "top-breweries", Brewery.top(3)
    Rails.cache.write "top-users", User.top(3)
    Rails.cache.write "top-styles", Style.top(3)
  end
end
