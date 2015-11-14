$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "coveralls"
require "codeclimate-test-reporter"

CodeClimate::TestReporter.start
Coveralls.wear!

require "five_star"
