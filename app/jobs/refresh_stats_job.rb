class RefreshStatsJob
  include SuckerPunch::Job

  def perform

    puts "Refreshing stats..."
    TopStatsHelper.cache_top_stats

    RefreshStatsJob.perform_in 10.minutes
  end
end
