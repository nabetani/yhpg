# frozen_string_literal: true

require 'minitest/autorun'
require_relative "solver"
require_relative "solve_slow"
require_relative "testcase"

class SolverTest < Minitest::Test
  def test_samples
    TESTCASES.each do |src|
      expected = solve_slow(src)
      actual = solve( src )
      assert_equal expected, actual, "src=#{src}"
    end
  end
end
