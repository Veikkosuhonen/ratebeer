class RefreshStatsJob
  include SuckerPunch::Job

  def perform
    puts "Refreshing stats..."
    TopStatsHelper.cache_top_stats

    # We dont want the job to keep running in CI
    if Rails.env.test?
      return
    end

    RefreshStatsJob.perform_in 10.minutes
  end
end
