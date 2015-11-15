# FiveStar

[![Build Status](https://travis-ci.org/rob-murray/five-star.svg?branch=master)](https://travis-ci.org/rob-murray/five-star)
[![Code Climate](https://codeclimate.com/github/rob-murray/five-star.png)](https://codeclimate.com/github/rob-murray/five-star)
[![Coverage Status](https://coveralls.io/repos/rob-murray/five-star/badge.svg?branch=master&service=github)](https://coveralls.io/github/rob-murray/five-star?branch=master)
[![Dependency Status](https://gemnasium.com/rob-murray/five-star.svg)](https://gemnasium.com/rob-murray/five-star)
[![Gem Version](https://badge.fury.io/rb/five-star.svg)](http://badge.fury.io/rb/five-star)


:star: **FiveStar** :star: is a library to build a rating system - it allows you to rate *something* in your domain by various classification or criteria you define. This library gives you the structure to rate your object with as many of these different classifications as you like with the overall rating calculated from the weighted average.

This uses Plain Old Ruby Objects so can be used in any project. Implement or use whatever persistence layer you want.

> Not sure if this is a gem or just a code design pattern :/

## Example

Say you implemented a film rating system, you have lots of `Film` objects each with different attributes and you would like to show an overall rating for each film based on classifications below. You might give the amount of swearing in the film slightly less weighting that the amount of sex and violence.

* Gore - Amount of blood in the movie - weighting: 40%
* Sex - Number of references to sex in the movie - weighting: 40%
* Swearing - Number of swear words in the movie - weighting: 20%

This could be implemented as follows.

```ruby
class Film
  include FiveStar.rateable

  rate_with GoreRater, SwearingRater, SexRater

  # rest of your implementation
  def blood_spilt
    # ...
  end

  def number_of_swear_words
    # ...
  end
end

class GoreRater < FiveStar.base_rater
  rating_weight 0.4

  def description
    "The film #{film.title} was rated #{rating} for gore"
  end

  def rating
    # count the pints of blood spilt in the film and return a rating
    if film.blood_spilt == :a_lot
      10
    elsif film.blood_spilt == :a_little
      5
    else
      0
    end
  end
end

class SwearingRater < FiveStar.base_rater
  rating_weight 0.2

  def description
    "The film #{film.title} has #{film.number_of_swear_words} and was rated at #{rating}"
  end

  def rating
    # count the number of swear words in the film & convert to our rating scale
    linear_conversion(film.number_of_swear_words)
  end
end

film = Film.new
film.rating # => 6
film.rating_descriptions # => ["The film Alien was rated 8 for gore", ...]

```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'five-star'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install five-star


## Usage

There are two components required, the thing being rated and how it is rated - the thing you want rated is defined as being rateable and you can have one or more rating classes to give it a rating. You must implement your these raters and provide the classes to the item being rated, this library takes care of the rest.

* `rateable` - This is the object that can be rated -  this is your domain model that has various attributes that you need rated.
* `rater` - A class that knows how to give a rating to the object being rated based on classification of the rateable's attributes.

Each `rater` must return a rating within the scale given and a weighting which will be used to calculate the overall rating.

The default rating scale used is 0 - 10 as floating point numbers although this can be overriden and customised.

The rating calculation will take the rating value from each rater along with the weighting to calculate the overall average rating.

### Rateable

This module when included gives the object the following interface on the instance.

* `rating` - `@return [Float]` -  The overall rating calculated for the rateable object.
* `rating_descriptions` - `@return [Array]` - A list of description from each raters. This is delegated to the rater.

The classes used to rate the object can be specified using the class method `rate_with(*class_names)` and passing in one or more rating classes.

```ruby
class Film
  include FiveStar.rateable

  rate_with GoreRater, SwearingRater, SexRater
  # ...
end

film = Film.new
film.rating # => 6
film.rating_descriptions # => ["The film Alien was rated 8 for gore", ...]
```

### Rater

You can create your own rating classes however you like but they should respond to the following methods;

* `build` - `@param [Rateable], @return [instance of rater]` - Create a new instance of rater with rateable as argument.
* `rating` - `@return [Float]` - The rating for the object being rated. Calculate this by your own classification.
* `description` - `@return [String]` - A description of the rating, eg reason it was rated at that value.
* `weighting` - `@return [Float]` - The weighting for this classification. Withing range 0.0 - 1.0

The **FiveStar** library will call the `build` method on the `Rater` with the argument of the instance of class being rated which should do any setup and return an instance of the rater.

For simplicity you can subclass `FiveStar.base_rater` and get the following for free. If the above methods are not overriden then the default implementation will be used.

* `rating_weight` - `@param [Float]` - Class method to set the weighting for this rater
* `rateable` - `@return [Rateable]` - Instance method referencing the object being rated
* `min_rating` - `@return [Float]` - Instance method returning the minimum rating value
* `max_rating` - `@return [Float]` - Instance method returning the maximum rating value

For example a basic version could be something like this;

```ruby
class GoreRater < FiveStar.base_rater
  rating_weight 0.4

  def description
    "The film #{film.title} has #{film.number_of_swear_words} and was rated at #{rating}"
  end

  def rating
    # calculate rating somehow
  end
end
```

### Rating calculation

The calculation used will be a weighted average based on each rating and the weighting defined in that class. If weighting is not required then all will be use the default value (of 1.0) and therefore be weighted the same, this being just a normal mean average calculation.

The default rating scale used is 0 - 10 as floating point numbers although this can be overriden and customised.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/five-star. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
