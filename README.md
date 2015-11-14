# FiveStar
### A generic rating library :star:

:star: **FiveStar** :star: is a library to build a rating system - it allows you to rate *something* in your system with some criteria you can define. This library gives you the structure to rate your object with as many different classifications.

This uses Plain Old Ruby Objects so can be used in any project. Implement or use whatever persistence layer you want.

> Not sure if this is a gem or just a code design pattern :/

## Example

Say you implemented a film rating system, you have lots of `Film` objects each with different attributes and you would like to show an overall rating for each film based on classifications below.

* Gore - Amount of blood in the movie - weighting: 40%
* Sex - Number of references to sex in the movie - weighting: 40%
* Swearing - Number of swear words in the movie - weighting: 20%

This could be implemented as follows.

```ruby
class Film
  include FiveStar.rateable

  rate_with GoreRater, SwearingRater, SexRater

  # rest of you implementation
end

class GoreRater < FiveStar.base_rater
  rating_weight 0.4

  def description
    "This Film was rated #{rating} for gore"
  end

  def rating
    # count the pints of blood spilt in the film
  end
end

class SwearingRater < FiveStar.base_rater
  rating_weight 0.2

  def description
    "This Film was has #{number_of_swear_words} and was rated at #{rating}"
  end

  def rating
    # count the pints of blood spilt in the film
  end
end

film = Film.new
film.rating # => 6
film.rating_descriptions # => ["This Film was rated 8 for gore", ...]

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

There are two components required, the thing being rated and how it is rated. You must implement your own rating class and provide the classes to the item being rated.

* `Rateable` - This is the object that can be rated based on
* `Rater` - A class that knows how to give a rating to the object being rated

Each `Rater` must return a rating within the scale given and a weighting which will be used to calculate the overall rating.

The current rating scale used is 0 - 10 as floating point numbers that can be rounded as you require.

### Rateable

This module when included gives the object the following interface on the instance.

* `rating` - `[Float]` -  The overall rating calculated from each rater class
* `rating_descriptions` - `Array` - A list of the description from each rater

The classes used to rate the object can be specified using the class method `rate_with(*class_names)` and passing in one or more rating classes.

```ruby
class Film
  include FiveStar.rateable

  rate_with GoreRater, SwearingRater, SexRater
...

film = Film.new
film.rating # => 6
film.rating_descriptions # => ["This Film was rated 8 for gore", ...]
```

### Rater

You can create your own rating classes however you like but they should respond to the following methods;

* `rating` - `[Float]` - The rating for the object being rated
* `description` - `[String]` - A description of the rating, eg reason it was rated at that value
* `weighting` - `[Float]` - The weighting for this classification

The **FiveStar** will call `build` method on the `Rater` with the argument of the instance of class being rated which should do any setup and return an instance of the rater.

For simplicity you can subclass `FiveStar.base_rater` and get the following for free.

* `rating_weight` - Class method to set the weighting for this rater
* `rateable` - Instance method referencing the object being rated
* `min_rating` - Instance method returning the minimum rating value
* `max_rating` - Instance method returning the maximum rating value

For example a basic version could be something like this;

```ruby
class GoreRater < FiveStar.base_rater
  rating_weight 0.4

  def description
    "This Film was rated #{rating} for gore"
  end

  def rating
    # calculate rating somehow
  end
end
```

### Rating calculation

The calculation used will be a weighted average based on each rating and the weighting. If weighting is not required then all will be weighted the same and so this is just a normal mean average calculation.

The minimum rating is 0.0 and the maximum is 10.0


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/five-star. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

