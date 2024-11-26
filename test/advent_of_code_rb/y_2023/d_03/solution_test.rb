# frozen_string_literal: true

require "minitest/autorun"

# {day_number}Test < Minitest::Test
class Day
  def setup
    @described_class = AdventOfCodeRb::Y # {year_number}::D#{day_number}::Solution
  end

  def test_part_1_passes
    assert @described_class.part1
  end

  def test_part_2_passes
    assert @described_class.part2
  end
end
