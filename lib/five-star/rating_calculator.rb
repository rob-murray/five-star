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
      raters.map { |rater|
        validate_rating!(rater.rating, rater) * validate_weighting!(rater.weighting, rater)
      }.inject(&:+)
    end

    def weights_total
      raters.map(&:weighting).inject(&:+)
    end

    def validate_rating!(rating, rater)
      #rating = rating.to_i
      if rating < 0 || rating > 10
        raise RatingError, "Rating #{rating} is invalid from #{rater.class}"
      else
        rating
      end
    end

    def validate_weighting!(weighting, rater)
      if weighting < 0.0 || weighting > 1.0
        raise RatingError, "Weighting #{weighting} is invalid from #{rater.class}"
      else
        weighting
      end
    end
  end
end
