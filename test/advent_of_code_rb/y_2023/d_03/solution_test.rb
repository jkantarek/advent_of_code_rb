# frozen_string_literal: true

require "minitest/autorun"

module AdventOfCodeRb::Y2023::D03
  class SolutionTest < Minitest::Test
    def setup
      @described_class = AdventOfCodeRb::Y2023::D03::Solution
    end

    def test_sample_passes
      assert_equal 4361, @described_class.sample
    end

    def test_part_1_passes
      assert_equal 0, @described_class.part1
    end

    def test_part_2_passes
      assert @described_class.part2
    end
  end
end
