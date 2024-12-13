# frozen_string_literal: true

module AdventOfCodeRb
  module Y2024
    module D08
      class Solution
        class Point
          attr_accessor :row, :col, :value

          def initialize(row, col, value)
            @row = row
            @col = col
            @value = value
          end

          def <=>(other)
            row_comparison = row <=> other.row
            return row_comparison unless row_comparison.zero?

            col <=> other.col
          end
        end

        class Node
          attr_reader :point1, :point2
          attr_accessor :anti_nodes

          def initialize(point1, point2)
            @point1 = point1
            @point2 = point2
            @anti_nodes = []
          end

          def sorted_points
            @sorted_points ||= [point1, point2].sort
          end

          def populate_anti_nodes(max_row:, max_col:)
            first_point, second_point = sorted_points
            n1 = [first_point.row - delta_rise, first_point.col + delta_run]
            anti_nodes << n1 if (0..max_row).include?(n1.first) && (0..max_col).include?(n1.last)
            n2 = [second_point.row + delta_rise, second_point.col - delta_run]
            anti_nodes << n2 if (0..max_row).include?(n2.first) && (0..max_col).include?(n2.last)
            anti_nodes
          end

          def delta_rise
            (point1.row - point2.row).abs
          end

          def delta_run
            (point1.col - point2.col).abs
          end
        end
        class << self
          def parse_file(filename: "input.txt")
            @parsed_file = File.open(File.expand_path(filename, __dir__)) do |file|
              max_row = 0
              max_col = 0
              file.each_with_object({ points: {} }).with_index do |(line, acc), row_index|
                max_row = row_index
                line.chomp.chars.each_with_index do |char, col_index|
                  max_col = col_index
                  acc[:points][[row_index, col_index]] = Point.new(row_index, col_index, char) if char != "."
                end
              end.merge({ max_row:, max_col: })
            end
          end

          def solution(max_row:, max_col:, points:)
            grouped_points = points.values.group_by(&:value)
            nodes = []
            grouped_points.each_value do |antenna_points|
              antenna_points.combination(2) do |point1, point2|
                nodes << Node.new(point1, point2)
              end
            end
            nodes.each { |node| node.populate_anti_nodes(max_row:, max_col:) }
            r = nodes.map(&:anti_nodes).each_with_object(Set.new) { |n, st| n.each { |nn| st.add(nn) } }
            (r.to_a - points.keys).count
          end

          def test_case
            result = parse_file(filename: "test_input.txt")
            solution(**result)
          end

          def part1
            result = parse_file
            solution(**result)
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
