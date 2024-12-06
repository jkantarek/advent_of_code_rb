# frozen_string_literal: true

module AdventOfCodeRb
  module Y2024
    module D05
      class Solution
        class << self
          def parse_file(filename: "input.txt")
            @parsed_file = File.open(File.expand_path(filename, __dir__)) do |file|
              contents = file.read
              page_order_rules, page_number_updates = contents.split("\n\n")
              collated_pages = collate_pages(page_order_rules.split("\n").map { |line| line.split("|").map(&:to_i) })
              {
                collated_pages: collated_pages,
                page_number_updates: page_number_updates.split("\n").map { |line| line.split(",").map(&:to_i) }
              }
            end
          end

          def solution(result)
            compute = result[:page_number_updates].map do |page_numbers|
              inspection_results = page_numbers.map.with_index do |page_number, idx|
                if idx.zero?
                  (page_numbers[1..] & result[:collated_pages][page_number][:before].to_a).any? ? :fail : :pass
                elsif (page_numbers[0...idx] & result[:collated_pages][page_number][:after].to_a).any? ||
                      (page_numbers[idx + 1..] & result[:collated_pages][page_number][:before].to_a).any?
                  :fail
                else
                  :pass
                end
              end
              front, _back = page_numbers.each_slice((page_numbers.size / 2.0).ceil).to_a
              {
                page_numbers: page_numbers,
                inspection_results: inspection_results,
                pass: inspection_results.none? { |r| r == :fail },
                middle_value: front.last
              }
            end
            compute.sum { |hsh| hsh[:pass] ? hsh[:middle_value] : 0 }
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

          def collate_pages(page_order_rules)
            page_order_rules.each_with_object({}) do |(before, after), hsh|
              hsh[before] ||= { before: Set.new, after: Set.new }
              hsh[before][:after].add(after)
              hsh[after] ||= { before: Set.new, after: Set.new }
              hsh[after][:before].add(before)
            end
          end
        end
      end
    end
  end
end
