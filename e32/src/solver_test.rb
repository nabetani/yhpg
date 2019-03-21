# frozen_string_literal: true

require 'minitest/autorun'
require_relative "solver"

class SolverTest < Minitest::Test
  def test_samples
    [
      [ "1ayd/b3gw/d7qq", "TBD" ],
    ].each do |src, expected|
      actual = solve( src )
      assert_equal expected, actual, "src=#{src}"
    end
  end
end

