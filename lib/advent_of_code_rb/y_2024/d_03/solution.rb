# frozen_string_literal: true

module AdventOfCodeRb
  module Y2024
    module D03
      class Solution
        MUL_PATTERN = /mul\(\d+,\d+\)/
        class << self
          def parse_file(filename: "input.txt", scan_pattern: MUL_PATTERN)
            @parsed_file = File.open(File.expand_path(filename, __dir__)) do |file|
              file.map { |l| l.scan(scan_pattern) }
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
            enabled = true
            acc = 0
            result.each do |line|
              line.each do |command|
                enabled, acc = process_command(command, enabled, acc)
              end
            end
            acc
          end

          def process_command(command, enabled, acc)
            case command.scan(/.+\(/).first
            when "mul("
              acc += command.scan(/\d+/).map(&:to_i).reduce(:*) if enabled
            when "don't("
              enabled = false
            when "do("
              enabled = true
            end
            [enabled, acc]
          end

          COMBINED_PATTERN = /
            mul\(\d+,\d+\)  # matches mul(n,m)
            |               # OR
            (?:don't\(\))   # matches don't()
            |               # OR
            (?:do\(\))      # matches do()
          /x

          def part2_test_case
            result = parse_file(filename: "test_input2.txt", scan_pattern: COMBINED_PATTERN)
            solution_part2(result)
          end

          def part2
            result = parse_file(scan_pattern: COMBINED_PATTERN)
            solution_part2(result)
          end
        end
      end
    end
  end
end
