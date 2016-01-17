module FiveStar
  # A module to be included to enhance an object with the interface below.
  module Rateable
    # Extends base class or a module with Rateable methods
    #
    # @param base [Object]
    #   the object to mix in this *Rateable* module
    #
    # @return [undefined]
    #
    # @api private
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # Set which rating classes will be used to rate the object
      # using this module.
      # Each class must implement the rater methods, see FiveStar::BaseRater
      #
      # @example
      #    class Film
      #      include FiveStar.rateable
      #
      #      rate_with GoreRater, SwearingRater, SexRater
      #      # ...
      #    end
      #
      # @param klasses [Class]
      #   constants referencing classes to rate object included with
      #
      # @return [undefined]
      #
      # @see FiveStar::BaseRater
      #
      # @api public
      def rate_with(*klasses)
        @rating_klasses = Array(klasses)
      end

      # Return which rating classes will be used to rate the object
      # using this module.
      #
      # @return [Array] list of classes to rate with
      #
      # @see FiveStar.rateable
      #
      # @api private
      def rating_klasses
        @rating_klasses ||= []
      end

      # Reference to Configuration used for this +rateable+ instance.
      #
      # @return [FiveStar::Configuration] Configuration instance in use
      #
      # @see FiveStar::Configuration
      #
      # @api private
      def configuration
        @configuration ||= Configuration.new
      end
    end

    # Return the rating given to the +rateable+ object by calculating based on
    # set raters and their configuration.
    #
    # @example
    #    film = Film.new
    #    film.rating # => 6.0
    #
    # @return [Float] rating calculated by set raters for the object
    #
    # @raise [FiveStar::RatingError] raises error if any raters return either
    #   +rating+ or +weighting+ that is outside of configuration bounds.
    #
    # @api public
    def rating
      rating_calculator.rate(self.class.configuration, raters)
    end

    # Return the rating description for each rater given to the +rateable+
    # object.
    # These are returned in the order in which the rating classes were
    # defined in +rate_with+.
    #
    # @example
    #    film = Film.new
    #    film.rating_descriptions # => ["The film Alien was rated 8 for gore", ...]
    #
    # @return [Array] list of descriptions from each rater
    #
    # @api public
    def rating_descriptions
      raters.map { |rater| rater.description }
    end

    # The name of the object that is rateable. This may be used by raters when
    # generating descriptions.
    # This can be overridden to provide a better response, otherwise is the class name.
    #
    # @return [String] name of the class
    #
    # @api public
    def rateable_name
      self.class.name
    end

    # Reference to Configuration used for this +rateable+ instance. Delegates to class.
    #
    # @return [FiveStar::Configuration] Configuration instance in use
    #
    # @api private
    def configuration
      self.class.configuration
    end

    protected

    # The instance that included this module
    #
    # @return [Object] self
    #
    # @api protected
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
