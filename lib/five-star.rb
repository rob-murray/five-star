require "five-star/version"
require "five-star/base_rater"
require "five-star/rateable"
require "five-star/rating_calculator"

module FiveStar
  class << self
    def rateable
      Rateable
    end

    def base_rater
      BaseRater
    end
  end
end
