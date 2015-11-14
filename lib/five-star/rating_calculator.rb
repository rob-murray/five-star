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

      sum_total = raters.map { |rater| rater.rating * rater.weighting }.inject(&:+)
      weights_total = raters.map(&:weighting).inject(&:+)

      sum_total / weights_total.to_f
    end

    private

    attr_reader :raters
  end
end
