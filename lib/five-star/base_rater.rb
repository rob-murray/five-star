module FiveStar
  # Base implementation of a class to give a rating, weighting and description
  #   to a +rateable+ instance.
  #
  # Default implementation is defined below, users should override methods
  #   with their own implementation.
  class BaseRater
    # Called to build a new instance of the rater with the given object
    #   being rated.
    #
    # @param [Object] rateable
    #   the instance of the Object being rated
    #
    # @return [Object] the instance created ready to rate
    #
    # @api public
    def self.build(rateable)
      new(rateable)
    end

    # Set the weighting for this rating classifcation class. This can be any
    #   valid floating point number at present, the weighting system is up to
    #   the user to ensure correct.
    #
    # @example
    #   class GoreRater < FiveStar.base_rater
    #     rating_weight 0.4
    #     # ...
    #   end
    #
    # @param [Float] weighting
    #   the weighting value
    #
    # @return [undefined]
    #
    # @api public
    def self.rating_weight(weighting)
      @weighting = weighting
    end

    # Return the weighting value for this rating classifcation class.
    #
    # @return [Float]
    #   the weighting value
    #
    # @api public
    def self.weighting
      @weighting ||= 1.0
    end

    # Create a new instance of rater
    #
    # @param [Object] rateable
    #   the instance of the Object being rated
    #
    # @api private
    def initialize(rateable)
      @rateable = rateable
    end

    # Return the rating description for the rater given to the `rateable`
    #   object.
    # Override to customise this message.
    #
    # @example
    #   class GoreRater < FiveStar.base_rater
    #     rating_weight 0.4
    #
    #     def description
    #       "The film #{film.title} has #{film.number_of_swear_words} and was rated at #{rating}"
    #     end
    #   end
    #
    #   rater.description # => "The film Alien was rated 8 for gore"
    #
    # @return [String] the description
    #
    # @api public
    def description
      "#{self.class} rated #{rateable_name} at #{rating} with weighting of #{weighting}"
    end

    # Return the rating for the rater given to the `rateable` object.
    # Override this method to perform your own calculation for the rating based
    #   on your own criteria. If this is an expensive operation then the result
    #   should be cached as this method *can* be called more than once, for
    #   example by the +description+ method.
    #
    # @example
    #   class GoreRater < FiveStar.base_rater
    #     rating_weight 0.4
    #
    #     def rating
    #       # count the pints of blood spilt in the film and return a rating
    #       if film.blood_spilt == :a_lot
    #         10
    #       elsif film.blood_spilt == :a_little
    #         5
    #       else
    #         0
    #       end
    #     end
    #   end
    #
    #   rater.rating # => 6
    #
    # @return [Float] the rating value
    #   defaults to 0 unless overridden
    #
    # @api public
    def rating
      0
    end

    # Return the weighting value for this rating classifcation class.
    #
    # @return [Float]
    #   the weighting value
    #
    # @api public
    def weighting
      self.class.weighting
    end

    protected

    attr_reader :rateable

    # Return the maximum weighting value for this rating classifcation class.
    #
    # Override if required - this should be the same for each rater class.
    #
    # @return [Fixnum]
    #   the maximum rating value.
    #
    # @api protected
    def max_rating
      10
    end

    # Return the minimum weighting value for this rating classifcation class.
    #
    # Override if required - this should be the same for each rater class.
    #
    # @return [Fixnum]
    #   the minimum rating value.
    #
    # @api protected
    def min_rating
      0
    end

    # Return the name of the given rateable instance.
    #
    # @return [String]
    #   the name of the object being rated.
    #
    # @api protected
    def rateable_name
      rateable.rateable_name
    end
  end
end
