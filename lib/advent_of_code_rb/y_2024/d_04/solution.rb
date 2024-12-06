# frozen_string_literal: true

module AdventOfCodeRb
  module Y2024
    module D04
      class Solution
        class << self
          def parse_file(filename: "input.txt", include_chars: %w[X M A S])
            @parsed_file = File.open(File.expand_path(filename, __dir__)) do |file|
              file.each_with_object({}).with_index do |(line, acc), row_idx|
                line.chomp.chars.each_with_index do |char, col_idx|
                  acc[[row_idx, col_idx]] = char if include_chars.include?(char)
                end
              end
            end
          end

          def solution(result)
            count = 0
            result.each do |(row_idx, col_idx), char|
              next unless char == "X"

              count += build_search_paths(result, row_idx, col_idx).first
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

          module SearchPaths
            RIGHT = lambda { |row_idx, col_idx, target_length|
              [[row_idx, col_idx], [row_idx, col_idx + 1], [row_idx, col_idx + 2],
               [row_idx, col_idx + 3]][0..target_length]
            }

            LEFT = lambda { |row_idx, col_idx, target_length|
              [[row_idx, col_idx], [row_idx, col_idx - 1], [row_idx, col_idx - 2],
               [row_idx, col_idx - 3]][0..target_length]
            }

            DOWN = lambda { |row_idx, col_idx, target_length|
              [[row_idx, col_idx], [row_idx + 1, col_idx], [row_idx + 2, col_idx],
               [row_idx + 3, col_idx]][0..target_length]
            }

            UP = lambda { |row_idx, col_idx, target_length|
              [[row_idx, col_idx], [row_idx - 1, col_idx], [row_idx - 2, col_idx],
               [row_idx - 3, col_idx]][0..target_length]
            }

            UP_LEFT = lambda { |row_idx, col_idx, target_length|
              [[row_idx, col_idx], [row_idx - 1, col_idx - 1], [row_idx - 2, col_idx - 2],
               [row_idx - 3, col_idx - 3]][0..target_length]
            }

            UP_RIGHT = lambda { |row_idx, col_idx, target_length|
              [[row_idx, col_idx], [row_idx - 1, col_idx + 1], [row_idx - 2, col_idx + 2],
               [row_idx - 3, col_idx + 3]][0..target_length]
            }

            DOWN_RIGHT = lambda { |row_idx, col_idx, target_length|
              [[row_idx, col_idx], [row_idx + 1, col_idx + 1], [row_idx + 2, col_idx + 2],
               [row_idx + 3, col_idx + 3]][0..target_length]
            }

            DOWN_LEFT = lambda { |row_idx, col_idx, target_length|
              [[row_idx, col_idx], [row_idx + 1, col_idx - 1], [row_idx + 2, col_idx - 2],
               [row_idx + 3, col_idx - 3]][0..target_length]
            }

            CENTER_TOP_LEFT_TO_BOTTOM_RIGHT = lambda { |row_idx, col_idx, target_length|
              [[row_idx - 1, col_idx - 1], [row_idx, col_idx], [row_idx + 1, col_idx + 1]][0..target_length]
            }

            CENTER_BOTTOM_LEFT_TO_TOP_RIGHT = lambda { |row_idx, col_idx, target_length|
              [[row_idx + 1, col_idx - 1], [row_idx, col_idx], [row_idx - 1, col_idx + 1]][0..target_length]
            }

            CENTER_TOP_LEFT_TO_BOTTOM_RIGHT_REVERSE = lambda { |row_idx, col_idx, target_length|
              CENTER_TOP_LEFT_TO_BOTTOM_RIGHT.call(row_idx, col_idx, target_length).reverse
            }

            CENTER_BOTTOM_LEFT_TO_TOP_RIGHT_REVERSE = lambda { |row_idx, col_idx, target_length|
              CENTER_BOTTOM_LEFT_TO_TOP_RIGHT.call(row_idx, col_idx, target_length).reverse
            }
          end

          DEFAULT_SEARCHES = [
            SearchPaths::RIGHT, SearchPaths::LEFT, SearchPaths::DOWN, SearchPaths::UP,
            SearchPaths::UP_LEFT, SearchPaths::UP_RIGHT, SearchPaths::DOWN_RIGHT, SearchPaths::DOWN_LEFT
          ].freeze

          XSEARCH1 = [SearchPaths::CENTER_TOP_LEFT_TO_BOTTOM_RIGHT,
                      SearchPaths::CENTER_TOP_LEFT_TO_BOTTOM_RIGHT_REVERSE].freeze

          XSEARCH2 = [SearchPaths::CENTER_BOTTOM_LEFT_TO_TOP_RIGHT,
                      SearchPaths::CENTER_BOTTOM_LEFT_TO_TOP_RIGHT_REVERSE].freeze

          def solution_part2(result)
            count = 0
            result.each do |(row_idx, col_idx), char|
              next unless char == "A"

              match1, = build_search_paths(result, row_idx, col_idx, string_matches: %w[MAS], searches: XSEARCH1)
              match2, = build_search_paths(result, row_idx, col_idx, string_matches: %w[MAS], searches: XSEARCH2)
              count += 1 if match1.positive? && match2.positive?
            end
            count
          end

          def part2_test_case
            result = parse_file(filename: "test_input.txt", include_chars: %w[M A S])
            solution_part2(result)
          end

          def part2
            result = parse_file(include_chars: %w[M A S])
            solution_part2(result)
          end

          private

          def build_search_paths(result, row_idx, col_idx, string_matches: ["XMAS"], searches: DEFAULT_SEARCHES)
            matches = 0
            r = searches.map do |search|
              found_string = search.call(row_idx, col_idx, string_matches.first.length - 1).map do |k|
                result[k]
              end.compact.join
              matches += 1 if string_matches.include?(found_string)

              found_string if string_matches.include?(found_string)
            end.compact

            [matches, r]
          end
        end
      end
    end
  end
end
