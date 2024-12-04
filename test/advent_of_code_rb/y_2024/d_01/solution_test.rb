# frozen_string_literal: true

require "minitest/autorun"

class AdventOfCodeRb::Y2024::D01Test < Minitest::Test
  def setup
    @described_class = AdventOfCodeRb::Y2024::D01::Solution
  end

  def test_test_case_passes
    assert_equal 11, @described_class.test_case
  end

  def test_part_1_passes
    assert_equal 1_722_302, @described_class.part1
  end

  def test_part_2_example_passes
    assert_equal 31, @described_class.part2_test_case
  end

  def test_part_2_passes
    assert_equal 20_373_490, @described_class.part2
  end
end
