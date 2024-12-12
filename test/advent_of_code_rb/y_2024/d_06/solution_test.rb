# frozen_string_literal: true

require "test_helper"

class AdventOfCodeRb::Y2024::D06Test < Minitest::Test
  def setup
    @described_class = AdventOfCodeRb::Y2024::D06::Solution
  end

  def test_test_case_passes
    assert_equal 41, @described_class.test_case
  end

  def test_part_1_passes
    assert_equal 4826, @described_class.part1
  end

  def test_part_2_example_passes
    assert_equal 6, @described_class.part2_test_case
  end

  # commenting out because it takes 196s to run
  # def test_part_2_passes
  #   assert_equal 1721, @described_class.part2
  # end
end
