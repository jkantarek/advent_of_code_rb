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
              sorted_list = build_sorting_list(collated_pages)
              indexed_list = sorted_list.each_with_object({}).with_index { |(v, hsh), idx| hsh[v] = idx }
              {
                collated_pages: collated_pages,
                page_number_updates: page_number_updates.split("\n").map { |line| line.split(",").map(&:to_i) },
                sorting_list: sorted_list,
                indexed_list:
              }
            end
          end

          def solution(result)
            compute = process_pages(result)
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
            compute = process_pages(result)
            compute.select { |c| !c[:pass] }.map do |hsh|
              # binding.irb
              # do comparitive lookup by indexed list to fix failing values
            end
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

          def process_pages(result)
            result[:page_number_updates].map do |page_numbers|
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
          end

          def collate_pages(page_order_rules)
            page_order_rules.each_with_object({}) do |(before, after), hsh|
              hsh[before] ||= { before: Set.new, after: Set.new }
              hsh[before][:after].add(after)
              hsh[after] ||= { before: Set.new, after: Set.new }
              hsh[after][:before].add(before)
            end
          end

          def build_sorting_list(collations)
            collations.keys.each_with_object([]) do |key, sorted_arr|
              if sorted_arr.empty?
                sorted_arr << key
              elsif sorted_arr.one?
                position = compare_values(sorted_arr.first, key, collations)
                if position.positive?
                  sorted_arr.push(key)
                else
                  sorted_arr.unshift(key)
                end
              else
                sorted_arr.each_cons(2).with_index do |(a, b), idx|
                  av = compare_values(a, key, collations)
                  bv = compare_values(key, b, collations)
                  if av != bv
                    sorted_arr.insert(idx + 1, key)
                    break
                  elsif av == bv && idx == sorted_arr.length - 1
                    sorted_arr.push(key)
                    break
                  elsif av == -1 && idx.zero?
                    sorted_arr.unshift(key)
                    break
                  end
                end
              end
            end
          end

          def compare_values(v1, v2, collations)
            if collations[v1][:before].include?(v2) || collations[v2][:after].include?(v1)
              -1 # [v2, v1]
            elsif collations[v1][:after].include?(v2) || collations[v2][:before].include?(v1)
              1 # [v1, v2]
            else
              binding.irb
            end
          end
        end
      end
    end
  end
end
