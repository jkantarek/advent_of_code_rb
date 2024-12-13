# frozen_string_literal: true

module AdventOfCodeRb
  module Y2024
    module D07
      class Solution
        class Operation
          attr_reader :expected_result, :values, :allowed_operands, :math_string

          def initialize(expected_result, values, allowed_operands: ["+", "*"])
            @expected_result = expected_result
            @values = values
            @allowed_operands = allowed_operands
          end

          def find_matching_expressions
            @math_strings = build_expressions_list(values)
            @math_string = @math_strings.find do |math_string|
              first_tuple = math_string.scan(/\d+.\d+/).first
              if first_tuple == math_string
                eval("#{expected_result} == (#{math_string})")
              else
                remainder = math_string[first_tuple.length..-1]
                res = remainder.scan(/\W\d+/).reduce(eval(first_tuple).to_i) do |acc, str|
                  eval("#{acc}#{str}")
                end
                expected_result == res
              end
            end
          end

          def build_expressions_list(values)
            operator_count = values.count - 1
            total_combinations = 2**operator_count # 2 operators, operator_count positions

            (0...total_combinations).map do |i|
              ops = operator_count.times.map do |pos|
                # Use bit at position to choose between + and *
                (i >> pos).nobits?(1) ? "+" : "*"
              end
              values.zip(ops).flatten.compact.join
            end
          end

          def result
            @values.sum
          end
        end

        class << self
          def parse_file(filename: "input.txt")
            @parsed_file = File.open(File.expand_path(filename, __dir__)) do |file|
              file.map do |line|
                expected_result, value_strings = line.split(":")
                values = value_strings.scan(/\d+/).map(&:to_i)
                Operation.new(expected_result.to_i, values)
              end
            end
          end

          def solution(result)
            found_operations = result.select(&:find_matching_expressions)
            found_operations.sum(&:expected_result)
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
            binding.irb
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
