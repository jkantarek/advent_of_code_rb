# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "advent_of_code_rb"

Dir.glob("lib/advent_of_code_rb/y_*/*/*.rb").each do |file|
  require file
end

require "minitest/autorun"
