module FiveStar
  class BaseRater
    def self.build(rateable)
      new(rateable)
    end

    def self.rating_weight(weighting)
      @weighting = weighting
    end

    def self.weighting
      @weighting ||= 1.0
    end

    def initialize(rateable)
      @rateable = rateable
    end

    def description
      "#{self.class} rated #{rateable.class} at #{rating} with weighting of #{weighting}"
    end

    def rating
      0
    end

    def weighting
      self.class.weighting
    end

    protected

    attr_reader :rateable

    def max_rating
      10
    end

    def min_rating
      0
    end
  end
end
