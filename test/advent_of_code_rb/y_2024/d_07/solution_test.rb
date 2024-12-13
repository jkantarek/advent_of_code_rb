# frozen_string_literal: true

require "test_helper"

class AdventOfCodeRb::Y2024::D07Test < Minitest::Test
  def setup
    @described_class = AdventOfCodeRb::Y2024::D07::Solution
  end

  def test_test_case_passes
    assert_equal 3749, @described_class.test_case
  end

  # def test_part_1_passes
  #   assert_equal 14_711_933_466_277, @described_class.part1
  # end

  def test_part_2_example_passes
    assert_equal 11_387, @described_class.part2_test_case
  end

  # def test_part_2_passes
  #   assert_equal 286_580_387_663_654, @described_class.part2
  # end
end
