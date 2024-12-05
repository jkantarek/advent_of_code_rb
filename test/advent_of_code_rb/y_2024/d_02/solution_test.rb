# frozen_string_literal: true

require "test_helper"

class AdventOfCodeRb::Y2024::D02::SolutionTest < Minitest::Test
  def setup
    @described_class = AdventOfCodeRb::Y2024::D02::Solution
  end

  def test_test_case_passes
    assert_equal 2, @described_class.test_case
  end

  def test_part_1_passes
    assert_equal 639, @described_class.part1
  end

  def test_part_2_example_passes
    assert_equal 4, @described_class.part2_test_case
  end

  def test_part_2_passes
    assert_equal 674, @described_class.part2
  end
end
