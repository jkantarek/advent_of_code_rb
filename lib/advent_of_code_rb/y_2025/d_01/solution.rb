# frozen_string_literal: true

module AdventOfCodeRb
  module Y2025
    module D01
      class Solution
        class << self
          def parse_file(filename: "input.txt")
            results = []
            @parsed_file = File.open(File.expand_path(filename, __dir__)) do |file|
              file.each_line do |line|
                elements = line.chars
                next if elements.empty?

                direction = elements.shift
                times = elements.join.to_i
                results << [direction, times]
              end
            end
            results
          end

          def solution(result)
            current_position = 50
            count_of_zeros = 0
            result.each_with_index do |(direction, count), idx|
              current_position ||= 0
              new_position =
                if direction == "L"
                  rotational_compensator(current_position - count)
                elsif direction == "R"
                  rotational_compensator(current_position + count)
                end
              count_of_zeros += 1 if new_position.zero?
              current_position = new_position
            end
            count_of_zeros
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
            current_position = 50
            count_of_zeros = 0
            result.each_with_index do |(direction, count), idx|
              current_position ||= 0
              new_position, passes =
                if direction == "L"
                  advanced_rotational_compensator(current_position - count)
                elsif direction == "R"
                  advanced_rotational_compensator(current_position + count)
                end
              count_of_zeros += 1 if new_position.zero?
              count_of_zeros += passes
              binding.irb
              current_position = new_position
            end
            count_of_zeros
          end

          def part2_test_case
            result = parse_file(filename: "test_input.txt")
            solution_part2(result)
          end

          def part2
            # result = parse_file
            # solution_part2(result)
          end

          private

          def rotational_compensator(value)
            return 0 if value == 100
            return value % 100 if value >= 0

            rotational_compensator(99 - value.abs + 1)
          end

          def advanced_rotational_compensator(value, current_passes: 0)
            return [0, current_passes] if value == 100
            return [value % 100, (value / 100)] if value >= 0

            next_value = 100 - value.abs
            [next_value % 100, 1 + (next_value / 100)]
          end
        end
      end
    end
  end
end
