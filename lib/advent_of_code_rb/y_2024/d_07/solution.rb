# frozen_string_literal: true

module AdventOfCodeRb
  module Y2024
    module D07
      class Solution
        class Operation
          attr_reader :expected_result, :values, :allowed_operands, :math_string, :math_strings
          attr_accessor :concat_found

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
                remainder = math_string[first_tuple.length..]
                res = remainder.scan(/\W\d+/).reduce(eval(first_tuple)) do |acc, str|
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

          def find_with_concat
            operators = %i[+ * |]
            operators.repeated_permutation(values.count - 1).any? do |ops|
              return true if calculate_iteration(ops)
            end
            false
          end

          def calculate_iteration(ops)
            v = ops.zip(values[1..]).flatten.each_slice(2).reduce(values.first) do |acc, (op, val)|
              return false if acc > expected_result

              if op == :|
                "#{acc}#{val}".to_i
              else
                acc.send(op, val)
              end
            end
            true if v == expected_result
          end

          def find_with_one_concat
            values_count = values.count
            if values_count == 2
              values.join.to_i == expected_result
            else
              math_strings.any? do |math_string|
                string_matcher(math_string) == true
              end
            end
          end

          def result
            @values.sum
          end

          private

          def string_matcher(math_string)
            operators = math_string.scan(/\W/)
            operators.each_with_index do |operator, index|
              v1, v2, *rest = values.dup
              res = if index.zero?
                      operators[1..].reduce([v1, v2].join.to_i) do |acc, operator|
                        acc.send(operator.to_sym, rest.shift)
                      end
                    else
                      line_idx = 1
                      operators[1..].reduce(v1.send(operator[0].to_sym, v2)) do |acc, operator|
                        if line_idx == index
                          line_idx += 1
                          [acc, rest.shift].join.to_i
                        else
                          line_idx += 1
                          acc.send(operator.to_sym, rest.shift)
                        end
                      end
                    end
              next unless res == expected_result

              @concat_found = {
                found_index: index
              }
              return true
            end
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
            # found_operations, remaining_operations = result.partition(&:find_matching_expressions)
            new_finds, _still_wrong = result.partition(&:find_with_concat)
            new_finds.sum(&:expected_result)
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
