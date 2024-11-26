# frozen_string_literal: true

module AdventOfCodeRb
  module Y2023
    module D03
      class Solution
        class << self
          def parse_file
            parser("input")
          end

          def parse_sample
            parser("sample_input")
          end

          def sample
            data = parse_sample
            solution(data)
          end

          def part1
            data = parse_file
            solution(data)
          end

          def part2
            false
          end

          private

          def parser(file_name)
            parsed_input = { digits: {}, markers: [], unique_markers: Set.new }
            File.open(File.expand_path("#{file_name}.txt", __dir__)) do |file|
              file.each_line("\n").with_index do |line, index|
                line.delete!("\n")
                digits = line.split(/\D/).reject(&:empty?).map { |value| { string_val: value, int: value.to_i } }
                digits.each do |digit|
                  d_start = line.index(digit[:string_val])
                  d_end = d_start + digit[:string_val].length
                  coords = { row: index, columns: d_start..d_end }
                  digit.merge!(coords: coords)
                  parsed_input[:digits][coords] = digit
                end

                line.chars.each_with_index do |c, marker_idx|
                  next if c == "." || c.match?(/\d/)

                  parsed_input[:markers] << { row: index, column: marker_idx }
                end
              end
            end

            parsed_input
          end

          def solution(data)
            matching_points = data[:markers].each_with_object(Set.new) do |marker, arr|
              exploded_coords = []
              exploded_coords << { row: marker[:row] - 1, column: marker[:column] - 1 }
              exploded_coords << { row: marker[:row] - 1, column: marker[:column] }
              exploded_coords << { row: marker[:row] - 1, column: marker[:column] + 1 }
              exploded_coords << { row: marker[:row], column: marker[:column] + 1 }
              exploded_coords << { row: marker[:row] + 1, column: marker[:column] + 1 }
              exploded_coords << { row: marker[:row] + 1, column: marker[:column] }
              exploded_coords << { row: marker[:row] + 1, column: marker[:column] - 1 }
              exploded_coords << { row: marker[:row], column: marker[:column] - 1 }

              found_points = data[:digits].select do |k, _v|
                exploded_coords.any? do |c|
                  k[:row] == c[:row] && k[:columns].include?(c[:column])
                end
              end

              found_points.each_value { |v| arr.add(v.merge) }
            end
            matching_points.sum { |v| v[:int] }
          end
        end
      end
    end
  end
end
