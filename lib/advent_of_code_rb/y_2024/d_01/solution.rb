# frozen_string_literal: true

module AdventOfCodeRb
  module Y2024
    module D01
      class Solution
        class << self
          def parse_file(filename: "input.txt")
            @parsed_file = File.open(File.expand_path(filename, __dir__)) do |file|
              file.each_with_object({ left: [], right: [] }) do |line, hsh|
                left, right = line.split(/\s+/).map(&:to_i)
                hsh[:left] << left
                hsh[:right] << right
              end
            end
          end

          def solution(result)
            left = result[:left]
            right = result[:right]
            left.sort!
            right.sort!

            left.map.with_index do |left_value, index|
              (left_value - right[index]).abs
            end.sum
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
            similarity_scores = result[:right].group_by { |v| v }.to_h { |v, c| [v, v * c.count] }
            result[:left].map do |left_value|
              similarity_scores.fetch(left_value, 0)
            end.sum
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
