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
            compute(result).select { |a| a[:status] == :safe }.count
          end

          def process_line(line)
            status = :safe
            direction = :unknown
            reason = nil
            line.each_with_index do |value, index|
              next if status == :unsafe

              this_direction = detect_direction(direction, value, line[index - 1], index)
              status, reason = detect_status(status, direction, this_direction, value, line[index - 1])
              direction = this_direction
            end
            { status:, line:, reason:, direction: }
          end

          def compute(result)
            result.map do |line|
              process_line(line)
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
            compute(result).select do |line|
              next true if line[:status] == :safe

              fix_found = false
              line[:line].each_with_index do |_, index|
                next if fix_found

                fix_found = true if compute([get_line_copy(line[:line], index)]).any? { |a| a[:status] == :safe }
              end
              fix_found
            end.count
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

          def get_line_copy(line, index)
            line_copy = line.dup
            line_copy.delete_at(index)
            line_copy
          end

          module StatusCheck
            RULES =
              [
                {
                  key: :already_unsafe,
                  new_status: :unsafe,
                  message: "already unsafe",
                  condition: ->(status, _, _, _, _) { status == :unsafe }
                },
                {
                  key: :no_change_in_value,
                  new_status: :unsafe,
                  message: "no change in value",
                  condition: lambda { |_, direction, this_direction, current_value, last_value|
                    current_value == last_value && direction == :unknown && this_direction == :unknown
                  }
                },
                {
                  key: :unknown_direction,
                  new_status: nil,
                  message: "unknown direction",
                  condition: lambda { |_, direction, this_direction, _, _|
                    direction == :unknown && this_direction == :unknown
                  }
                },
                {
                  key: :direction_mismatch,
                  new_status: :unsafe,
                  message: "direction mismatch",
                  condition: lambda { |_, direction, this_direction, _, _|
                    %i[ascending descending].include?(direction) && this_direction != direction
                  }
                },
                {
                  key: :no_change_in_value,
                  new_status: :unsafe,
                  message: "no change in value",
                  condition: lambda { |_, _, _, current_value, last_value|
                    current_value == last_value
                  }
                },
                {
                  key: :value_change_too_large,
                  new_status: :unsafe,
                  message: "value change too large",
                  condition: lambda { |_, _, _, current_value, last_value|
                    (current_value - last_value).abs > 3
                  }
                }
              ].freeze
          end

          def detect_status(status, direction, this_direction, current_value, last_value)
            match = StatusCheck::RULES.find do |rule|
              rule[:condition].call(status, direction, this_direction, current_value, last_value)
            end
            return [match[:new_status] || status, match[:message]] if match

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
