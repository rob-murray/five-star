module FiveStar
  # Calculate overall rating for the rateable object from each rater.
  # Each instance must implement +rating+ and +weighting+.
  # The configuration instance provides min and max rating and weighting values.
  #
  # @api private
  class RatingCalculator
    # @see calculate_rating
    def self.rate(configuration, raters)
      new(configuration, raters).calculate_rating
    end

    def initialize(configuration, raters)
      @configuration = configuration
      @raters = raters
    end

    # Calculate the overall weighting from each rating class
    #
    # @return [Float] the calculated rating
    #    The min rating will be returned if there are no raters.
    #
    # @raise [FiveStar::RatingError] raises error if any raters return either
    #   +rating+ or +weighting+ that is outside of configuration bounds.
    #
    # @api private
    def calculate_rating
      return min_rating unless raters.any?

      sum_total / weights_total
    end

    private

    attr_reader :raters, :configuration

    def sum_total
      raters.map { |rater|
        validate_rating!(rater.rating, rater) * validate_weighting!(rater.weighting, rater)
      }.reduce(&:+)
    end

    def weights_total
      raters.map(&:weighting).reduce(&:+)
    end

    def validate_rating!(rating, rater)
      rating = rating.to_f

      if rating < min_rating || rating > max_rating
        raise RatingError, "Rating #{rating} is invalid from #{rater.class}"
      else
        rating
      end
    end

    def validate_weighting!(weighting, rater)
      weighting = weighting.to_f

      if weighting < min_weighting || weighting > max_weighting
        raise RatingError, "Weighting #{weighting} is invalid from #{rater.class}"
      else
        weighting
      end
    end

    def min_rating
      configuration.min_rating
    end

    def max_rating
      configuration.max_rating
    end

    def min_weighting
      configuration.min_weighting
    end

    def max_weighting
      configuration.max_weighting
    end
  end
end
