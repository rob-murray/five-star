module FiveStar
  module Rateable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def rate_with(*klasses)
        @rating_klasses = Array(klasses)
      end

      def rating_klasses
        @rating_klasses ||= []
      end
    end

    def rating
      rating_calculator.rate(raters)
    end

    def rating_descriptions
      raters.map { |rater| rater.description }
    end

    protected

    def rateable
      self
    end

    private

    def raters
      @raters ||= rating_klasses.map { |rater| rater.build(rateable) }
    end

    def rating_klasses
      rateable.class.rating_klasses
    end

    def rating_calculator
      RatingCalculator
    end
  end
end
