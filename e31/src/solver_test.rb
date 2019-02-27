# frozen_string_literal: true

require 'minitest/autorun'
require_relative "solver"
require_relative "solve_slow"

class SolverTest < Minitest::Test
  def test_samples
    [
      "2,10",
      "10,100",
      "10,122",
      "10,123",
      "10,124",
      "10,998",
      "10,999",
      "10,1122",
      "10,1234",
      "10,789",
    ].each do |src|
      expected = solve_slow(src)
      actual = solve( src )
      assert_equal expected, actual, "src=#{src}"
    end
  end
end
