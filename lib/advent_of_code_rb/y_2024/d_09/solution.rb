# frozen_string_literal: true

module AdventOfCodeRb
  module Y2024
    module D09
      class Solution
        class << self
          def parse_file(filename: "input.txt", linear: true)
            @parsed_file = File.open(File.expand_path(filename, __dir__)) do |file|
              disk = []
              if linear
                idx = 0
                file.readline.chomp.chars.each_slice(2) do |used, empty|
                  disk += Array.new(used.to_i, idx)
                  idx += 1
                  disk += Array.new(empty.to_i, ".")
                end
                disk
              else
                free_spaces = {}
                blocks = {}
                idx = 0
                file.readline.chomp.chars.each_slice(2) do |used, empty|
                  blocks[disk.length] = (0..used.to_i - 1)
                  disk += Array.new(used.to_i, idx)
                  idx += 1

                  free_spaces[disk.length] = build_range(empty.to_i)
                  disk += Array.new(empty.to_i, ".")
                end
                { disk:, free_spaces:, blocks: }
              end
            end
          end

          def solution(result)
            result.each_with_index do |v, idx|
              result.pop while result[-1] == "."
              next unless v == "."

              result[idx] = result.pop
            end
            calculate_checksum(result)
          end

          def calculate_checksum(disk)
            idx = 0
            disk.reduce(0) do |acc, v|
              next acc if v == "."

              acc += (idx * v)
              idx += 1
              acc
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

          def solution_part2(free_spaces:, disk:, blocks:)
            blocks.to_a.reverse.each do |index, size_of_block|
              found_idx, open_range = free_spaces.find { |_i, range| range.cover?(size_of_block) }
              next unless found_idx

              remaining_range = open_range.max - size_of_block.max - 1
              free_spaces.delete(found_idx)
              free_spaces[found_idx + size_of_block.max] = 0..remaining_range

              size_of_block.to_a.each do |rewrite_idx|
                source_v = disk[index + rewrite_idx]
                disk[index + rewrite_idx] = "."
                binding.irb if disk[found_idx + rewrite_idx] != "."
                disk[found_idx + rewrite_idx] = source_v
              end
            end
            binding.irb
            calculate_checksum(disk)
          end

          def part2_test_case
            result = parse_file(filename: "test_input.txt", linear: false)
            solution_part2(**result)
          end

          def part2
            result = parse_file
            solution_part2(**result)
          end

          private

          def build_range(empty)
            return 0..0 if empty.zero?

            0..(empty - 1)
          end
        end
      end
    end
  end
end
