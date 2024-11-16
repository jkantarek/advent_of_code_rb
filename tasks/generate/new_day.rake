# frozen_string_literal: true

namespace :generate do
  desc "Generate a new day scaffold"
  task :new_day, [:year_number, :day_number] do |_t, args|
    year_number = args[:year_number] || Time.now.year
    last_day =
      Dir
      .glob("lib/advent_of_code_rb/y_#{year_number}/*")
      .map do |days|
        days
          .split("/d_")
          .last
          .to_i
      end
      .max
    next_day_number = (last_day || 0) + 1
    day_number = args[:day_number] || next_day_number

    test_path = "test/advent_of_code_rb/y_#{year_number}/d_#{day_number}"
    lib_path = "lib/advent_of_code_rb/y_#{year_number}/d_#{day_number}"
    [test_path, lib_path].each do |path|
      FileUtils.mkpath(path)
    end

    puts "Generating scaffold for Day #{day_number}"

    File.open("lib/advent_of_code_rb.rb", "r+") do |file|
      next if file.read.match?("module AdventOfCodeRb::Y#{year_number}; end")

      file.puts("\nmodule AdventOfCodeRb::Y2024; end")
    end

    FileUtils.touch("lib/advent_of_code_rb/y_#{year_number}/y_#{year_number}.rb")

    File.open("lib/advent_of_code_rb/y_#{year_number}/y_#{year_number}.rb", "r+") do |file|
      next if file.read.match?("module AdventOfCodeRb::Y#{year_number}::D#{day_number}; end")

      file.puts("\nmodule AdventOfCodeRb::Y#{year_number}::D#{day_number}; end")
    end

    # Create main Ruby file for the day
    File.open("#{lib_path}/solution.rb", "w") do |file|
      file.puts <<~RUBY
        module AdventOfCodeRb
          module Y#{year_number}
            module D#{day_number}
              class Solution
                class << self

                  def parse_file
                    @parsed_file = File.open(File.expand_path("input.txt", __dir__)) do |file|
                      binding.irb
                    end
                  end

                  def part1
                    data = parse_file
                  end

                  def part2
                    false
                  end
                end
              end
            end
          end
        end
      RUBY
    end

    # Create test file
    File.open("#{test_path}/solution_test.rb", "w") do |file|
      file.puts <<~RUBY
        require 'minitest/autorun'

        class Day#{day_number}Test < Minitest::Test
          def setup
            @described_class = AdventOfCodeRb::Y#{year_number}::D#{day_number}::Solution
          end

          def test_part_1_passes
            assert @described_class.part1
          end

          def test_part_2_passes
            assert @described_class.part2
          end
        end
      RUBY
    end

    # Create input file
    File.open("#{lib_path}/input.txt", "w") do |file|
      file.puts "# TODO: Add puzzle input here"
    end

    puts "Scaffold for Day #{day_number} created successfully!"
  end
end
