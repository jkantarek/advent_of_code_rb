# frozen_string_literal: true

module AdventOfCodeRb
  module Y2023
    module D03
      class Solution
        class << self
          def parse_file
            @parsed_file = File.open(File.expand_path("input.txt", __dir__)) do |file|
              binding.irb
            end
          end

          def part1
            parse_file
          end

          def part2
            false
          end
        end
      end
    end
  end
end
