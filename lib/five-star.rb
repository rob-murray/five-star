require "five-star/version"
require "five-star/base_rater"
require "five-star/configuration"
require "five-star/rateable"
require "five-star/errors"
require "five-star/rating_calculator"

# Base module for library interface
module FiveStar
  class << self
    # Include this in your class that can be rated - this is your domain model
    # object that has various attributes that you need rated.
    # Being +rateable+ is defined as an object that has attributes on which a
    # rating can be calculated based on varying attributes of that model.
    #
    # This adds the public class and instance methods from the Rateable module.
    #
    # @example
    #   class Film
    #     include FiveStar.rateable
    #
    #     rate_with GoreRater, SwearingRater, SexRater
    #     # ...
    #   end
    #
    # @see FiveStar::Rateable
    #
    # @return [Class]
    #
    # @api public
    def rateable
      Rateable
    end

    # The base class of a class that gives a rating and weighting to something
    # that is rateable. See FiveStar.rateable.
    #
    # This implements the interface necessary to calculate a rating for the
    # rateable instance. At a minimum this must be +build+, +rating+,
    # +description+ and +weighting+.
    #
    # The method +build+ *will* be called on each class with the argument of
    # the instance being rated.
    #
    # @example
    #   class GoreRater < FiveStar.base_rater
    #     rating_weight 0.4
    #
    #     def description
    #       "The Film #{film.title} has #{film.number_of_swear_words} and was rated at #{rating}"
    #     end
    #
    #     def rating
    #       # calculate rating somehow
    #     end
    #   end
    #
    # @see FiveStar::BaseRater
    #
    # @return [Class]
    #
    # @api public
    def base_rater
      BaseRater
    end
  end
end
