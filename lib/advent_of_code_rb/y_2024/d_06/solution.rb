# frozen_string_literal: true

require "timeout"

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/ParameterLists
# rubocop:disable Metrics/ClassLength
module AdventOfCodeRb
  module Y2024
    module D06
      class Solution
        class << self
          def parse_file(filename: "input.txt")
            @parsed_file = File.open(File.expand_path(filename, __dir__)) do |file|
              block_locations = []
              starting_location = nil
              max_row = 0
              max_col = 0
              grid = file.each_with_object({}).with_index do |(line, acc), row_idx|
                max_row = line.chomp.length
                line.chomp.chars.each_with_index do |char, col_idx|
                  max_col = col_idx if col_idx > max_col
                  acc[[row_idx, col_idx]] = char
                  block_locations << [row_idx, col_idx] if char == "#"
                  starting_location = [row_idx, col_idx] if char == "^"
                end
              end
              { block_locations:, starting_location:, grid:, max_row:, max_col: }
            end
          end

          def solution(result)
            finished_grid = find_locations_visited(direction: :up,
                                                   location: result[:starting_location],
                                                   block_locations: result[:block_locations],
                                                   grid: result[:grid],
                                                   max_row: result[:max_row],
                                                   max_col: result[:max_col])
            # finished_grid[result[:starting_location]] = "^"
            # print_grid(finished_grid, result[:max_row], result[:max_col])
            finished_grid.values.reduce(0) { |acc, v| ["X", "^", "+", "-", "|"].include?(v) ? acc + 1 : acc }
          end

          def print_grid(grid, max_row, max_col)
            puts "==========="
            (0..max_row).each do |row|
              (0..max_col).each do |col|
                print(grid[[row, col]] || " ")
              end
              puts
            end
            puts "==========="
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
            finished_grid = find_locations_visited(direction: :up,
                                                   location: result[:starting_location],
                                                   block_locations: result[:block_locations],
                                                   grid: result[:grid],
                                                   max_row: result[:max_row],
                                                   max_col: result[:max_col])
            # finished_grid[result[:starting_location]] = "^"
            # print_grid(finished_grid, result[:max_row], result[:max_col])
            found_loops = finished_grid.select { |_k, v| v == "X" }.select do |sub_block, _v|
              grid_itr = find_locations_visited_with_timeout(direction: :up,
                                                             location: result[:starting_location],
                                                             block_locations: result[:block_locations] + [sub_block],
                                                             grid: result[:grid].merge(sub_block => "#"),
                                                             max_row: result[:max_row],
                                                             max_col: result[:max_col])
              grid_itr.nil?
            end
            found_loops.count
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

          def inject_final_corner(arr)
            r1, r2 = arr.group_by(&:first).keys
            c1, c2 = arr.group_by(&:last).keys
            [[r1, c1], [r1, c2], [r2, c1], [r2, c2]].sort
          end

          def find_locations_visited_with_timeout(direction:, location:, block_locations:, grid:, max_row:, max_col:)
            print "#{["|", "/", "-", "\\"][Time.now.usec % 4]}\r"
            Timeout.timeout(0.0001) do
              find_locations_visited(direction: direction, location: location, block_locations: block_locations,
                                     grid: grid, max_row: max_row, max_col: max_col)
            end
          rescue Timeout::Error, SystemStackError
            nil
          end

          def find_locations_visited(direction:, location:, block_locations:, grid:, max_row:, max_col:)
            return grid if direction == :finish

            next_loc = next_location(direction: direction, location: location, block_locations: block_locations,
                                     max_row: max_row, max_col: max_col)
            next_loc[:locations_visited].each do |(loc, _value_override)|
              grid[loc] = case grid[loc]
                          when "#"
                            "&"
                          when nil
                            "*"
                          else
                            "X"
                          end
            end
            find_locations_visited(direction: next_loc[:direction],
                                   location: next_loc[:position],
                                   block_locations: block_locations,
                                   grid: grid,
                                   max_row: max_row,
                                   max_col: max_col)
          end

          def next_location(direction:, location:, block_locations:, max_row:, max_col:)
            row, col = location

            case direction
            when :up
              candidates = block_locations.select { |r, c| r < row && c == col }
              if candidates.empty?
                return {
                  old_position: [row, col],
                  position: [-1, col],
                  locations_visited: re_key((0..row).to_a.map { |i| [i, col] }, "+", "|", "|"),
                  direction: :finish
                }
              end
              new_row, new_col = candidates.max_by { |r, _c| r }
              {
                old_position: [row, col],
                position: [new_row + 1, new_col],
                locations_visited: re_key((0..(row - new_row - 2)).to_a.map { |i| [row - i, col] }, "+", "|", "|"),
                direction: :right
              }
            when :right
              candidates = block_locations.select { |r, c| r == row && c > col }
              if candidates.empty?
                return {
                  old_position: [row, col],
                  position: [row, max_col + 1],
                  locations_visited: re_key((0..(max_col - col - 2)).to_a.map { |i| [row, col + i] }, "+", "-", "-"),
                  direction: :finish
                }
              end
              new_row, new_col = candidates.min_by { |_r, c| c }
              {
                old_position: [row, col],
                position: [new_row, new_col - 1],
                locations_visited: re_key((0..(new_col - col - 2)).to_a.map { |i| [row, col + i] }, "+", "-", "-"),
                direction: :down
              }
            when :down
              candidates = block_locations.select { |r, c| r > row && c == col }
              if candidates.empty?
                return {
                  old_position: [row, col],
                  position: [max_row + 1, col],
                  locations_visited: re_key((row..max_row - 1).to_a.map { |i| [i, col] }, "+", "|", "|"),
                  direction: :finish
                }
              end
              new_row, new_col = candidates.min_by { |r, _c| r }
              {
                old_position: [row, col],
                position: [new_row - 1, new_col],
                locations_visited: re_key((0..(new_row - row - 2)).to_a.map { |i| [row + i, col] }, "+", "|", "|"),
                direction: :left
              }
            when :left
              candidates = block_locations.select { |r, c| r == row && c < col }
              if candidates.empty?
                return {
                  old_position: [row, col],
                  position: [row, -1],
                  locations_visited: re_key((0..(max_col - col - 2)).to_a.map { |i| [row, col - i] }, "+", "-", "-"),
                  direction: :finish
                }
              end
              new_row, new_col = candidates.max_by { |_r, c| c }
              {
                old_position: [row, col],
                position: [new_row, new_col + 1],
                locations_visited: re_key((0..(col - new_col - 2)).to_a.map { |i| [row, col - i] }, "+", "-", "-"),
                direction: :up
              }
            else
              raise "Invalid direction: #{direction}"
            end
          end

          def re_key(arr, start_symbol, run_symbol, end_symbol)
            max = arr.length
            arr.map.with_index do |(i, v), idx|
              if [max, 0].include?(idx)
                [[i, v], start_symbol]
              elsif idx == max - 1
                [[i, v], end_symbol]
              else
                [[i, v], run_symbol]
              end
            end
          end
        end
      end
    end
  end
end

# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/ParameterLists
# rubocop:enable Metrics/ClassLength
