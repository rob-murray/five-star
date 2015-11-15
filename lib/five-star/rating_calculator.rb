module FiveStar
  # Calculate overall rating for the rateable object from each rater.
  #   Each instance must implement `rating` and `weighting`.
  # @api private
  class RatingCalculator
    def self.rate(raters)
      new(raters).calculate_rating
    end

    def initialize(raters)
      @raters = raters
    end

    # Calculate the overall weighting from each rating class
    #
    # @return [Float] the calculated rating
    #
    # @api private
    def calculate_rating
      return 0 unless raters.any?

      sum_total / weights_total.to_f
    end

    private

    attr_reader :raters

    def sum_total
      raters.map { |rater| rater.rating * rater.weighting }.inject(&:+)
    end

    def weights_total
      raters.map(&:weighting).inject(&:+)
    end
  end
end
