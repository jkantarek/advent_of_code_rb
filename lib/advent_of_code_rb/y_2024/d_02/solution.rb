# frozen_string_literal: true

module AdventOfCodeRb
  module Y2024
    module D02
      class Solution
        class << self
          def parse_file(filename: "input.txt")
            @parsed_file = File.open(File.expand_path(filename, __dir__)) do |file|
              file.each_with_object([]) do |line, acc|
                acc << line.split(/\s+/).map(&:to_i)
              end
            end
          end

          def solution(result)
            answer = result.map do |line|
              status = :safe
              direction = :unknown
              reason = nil
              last_index = 0
              line.each_with_index do |value, index|
                next if status == :unsafe

                last_index = index

                this_direction = detect_direction(direction, value, line[index - 1], index)
                status, reason = detect_status(status, direction, this_direction, value, line[index - 1])
                direction = this_direction
              end
              { status:, line:, reason:, direction:, last_index: last_index }
            end
            answer.select { |a| a[:status] == :safe }.count
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

          def detect_status(status, direction, this_direction, current_value, last_value)
            return [:unsafe, "already unsafe"] if status == :unsafe

            if current_value == last_value && direction == :unknown && this_direction == :unknown
              return [:unsafe, "no change in value"]
            end
            return [status, "unknown direction"] if direction == :unknown && this_direction == :unknown
            return [:unsafe, "direction mismatch"] if %i[ascending
                                                         descending].include?(direction) && this_direction != direction

            return [:unsafe, "no change in value"] if current_value == last_value
            return [:unsafe, "value change too large"] if (current_value - last_value).abs > 3

            [:safe, "All good"]
          end

          def detect_direction(current_direction, current_value, last_value, index)
            return :unknown if index.zero?
            return :unknown if last_value.nil?
            return current_direction if current_value == last_value

            if current_value > last_value
              :ascending
            elsif current_value < last_value
              :descending
            end
          end
        end
      end
    end
  end
end
