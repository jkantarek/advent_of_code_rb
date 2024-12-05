# frozen_string_literal: true

module AdventOfCodeRb
  module Y2024
    module D03
      class Solution
        class << self
          def parse_file(filename: "input.txt")
            @parsed_file = File.open(File.expand_path(filename, __dir__)) do |file|
              file.map { |l| l.scan(/mul\(\d+,\d+\)/) }
            end
          end

          def solution(result)
            result.reduce(0) do |acc, line|
              acc + line.map { |m| m.scan(/\d+/).map(&:to_i).reduce(:*) }.sum
            end
          end

          def test_case
            result = parse_file(filename: "test_input.txt")
            solution(result)
          end

          def part1
            result = parse_file
            solution(result)
          end

          def solution_part2(result)
            # binding.irb
            0
          end

          def part2_test_case
            result = parse_file(filename: "test_input.txt")
            solution_part2(result)
          end

          def part2
            result = parse_file
            solution_part2(result)
          end
        end
      end
    end
  end
end
