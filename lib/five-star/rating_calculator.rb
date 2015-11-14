module FiveStar
  class RatingCalculator
    def self.rate(raters)
      new(raters).calculate_rating
    end

    def initialize(raters)
      @raters = raters
    end

    def calculate_rating
      return 0 unless raters.any?
      rating_and_weights = raters.map{ |rater| [rater.rating, rater.weighting] }

      totals = rating_and_weights.map { |rating, weight| rating * weight }
      weights = rating_and_weights.map { |_rating, weight| weight }
      total = totals.inject(&:+)
      weight_total = weights.inject(&:+)

      total / weight_total.to_f
    end

    private

    attr_reader :raters
  end
end
