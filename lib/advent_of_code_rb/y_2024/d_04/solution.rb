# frozen_string_literal: true

module AdventOfCodeRb
  module Y2024
    module D04
      class Solution
        class << self
          def parse_file(filename: "input.txt")
            @parsed_file = File.open(File.expand_path(filename, __dir__)) do |file|
              file.each_with_object({}).with_index do |(line, acc), row_idx|
                line.chomp.chars.each_with_index do |char, col_idx|
                  acc[[row_idx, col_idx]] = char if %w[X M A S].include?(char)
                end
              end
            end
          end

          def solution(result)
            count = 0
            result.each do |(row_idx, col_idx), char|
              next unless char == "X"

              count += build_search_paths(result, row_idx, col_idx)
            end
            count
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

          private

          def build_search_paths(result, row_idx, col_idx)
            matches = 0
            right_path = [
              [row_idx, col_idx],
              [row_idx, col_idx + 1],
              [row_idx, col_idx + 2],
              [row_idx, col_idx + 3]
            ].map { |k| result[k] }.compact.join("")
            matches += 1 if right_path == "XMAS"

            left_path = [
              [row_idx, col_idx],
              [row_idx, col_idx - 1],
              [row_idx, col_idx - 2],
              [row_idx, col_idx - 3]
            ].map { |k| result[k] }.compact.join("")
            matches += 1 if left_path == "XMAS"

            down_path = [
              [row_idx, col_idx],
              [row_idx + 1, col_idx],
              [row_idx + 2, col_idx],
              [row_idx + 3, col_idx]
            ].map { |k| result[k] }.compact.join("")
            matches += 1 if down_path == "XMAS"

            up_path = [
              [row_idx, col_idx],
              [row_idx - 1, col_idx],
              [row_idx - 2, col_idx],
              [row_idx - 3, col_idx]
            ].map { |k| result[k] }.compact.join("")
            matches += 1 if up_path == "XMAS"

            up_left_path = [
              [row_idx, col_idx],
              [row_idx - 1, col_idx - 1],
              [row_idx - 2, col_idx - 2],
              [row_idx - 3, col_idx - 3]
            ].map { |k| result[k] }.compact.join("")
            matches += 1 if up_left_path == "XMAS"

            up_right_path = [
              [row_idx, col_idx],
              [row_idx - 1, col_idx + 1],
              [row_idx - 2, col_idx + 2],
              [row_idx - 3, col_idx + 3]
            ].map { |k| result[k] }.compact.join("")
            matches += 1 if up_right_path == "XMAS"

            down_right_path = [
              [row_idx, col_idx],
              [row_idx + 1, col_idx + 1],
              [row_idx + 2, col_idx + 2],
              [row_idx + 3, col_idx + 3]
            ].map { |k| result[k] }.compact.join("")
            matches += 1 if down_right_path == "XMAS"

            down_left_path = [
              [row_idx, col_idx],
              [row_idx + 1, col_idx - 1],
              [row_idx + 2, col_idx - 2],
              [row_idx + 3, col_idx - 3]
            ].map { |k| result[k] }.compact.join("")
            matches += 1 if down_left_path == "XMAS"

            matches
          end
        end
      end
    end
  end
end
