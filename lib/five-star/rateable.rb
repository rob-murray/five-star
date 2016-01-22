module FiveStar
  # A module to be included to enhance an object with the interface below
  module Rateable
    # Extends base class or a module with Rateable methods
    #
    # @param [Object] object
    #   the object to mix in this +Rateable+ module
    #
    # @return [undefined]
    #
    # @api private
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # Set which rating classes will be used to rate the object
      #  using this module.
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
      # @param [Class] *klasses
      #   constants referencing classes to rate object included with
      #
      # @return [undefined]
      #
      # @see FiveStar.rateable
      #
      # @api public
      def rate_with(*klasses)
        @rating_klasses = Array(klasses)
      end

      # Define which rating classes will be used to rate the object
      #  using this module.
      #
      # @return [Array] list of classes to rate with
      #
      # @see FiveStar.rateable
      #
      # @api private
      def rating_klasses
        @rating_klasses ||= []
      end
    end

    # Return the rating given to the `rateable` object by calculating based on
    #   set raters and their configuration.
    #
    # @example
    #    film = Film.new
    #    film.rating # => 6
    #
    # @return [Float] rating calculated by set raters for the object
    #
    # @api public
    def rating
      rating_calculator.rate(config, raters)
    end

    # Return the rating description for each rater given to the `rateable`
    #   object.
    # These are returned in the order in which the rating classes were
    #   defined in `rate_with`.
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

    # The name of the object that is rateable. This may be used by raters
    #   when generating descriptions.
    # This can be overridden to provide a better response, otherwise is the class
    #   name.
    #
    # @return [String] name of the class
    #
    # @api public
    def rateable_name
      self.class.name
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

    def config
      @config ||= Configuration.new
    end
  end
end
