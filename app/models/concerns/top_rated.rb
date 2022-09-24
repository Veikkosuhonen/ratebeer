module TopRated
  extend ActiveSupport::Concern

  def top(count)
    all.sort_by { |b| -(b.average_rating || 0) }.take count
  end
end
