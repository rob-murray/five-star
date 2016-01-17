module FiveStar
  # Default configuration of rating values and weighting.
  #
  # @api private
  class Configuration
    DEFAULT_WEIGHTING = 1.0.freeze

    def min_rating; 0.0; end
    def max_rating; 10.0; end

    def min_weighting; 0.0; end
    def max_weighting; 1.0; end
  end
end
