require 'minitest/autorun'
require_relative "solver"

class SolverTest < Minitest::Test
  def test_samples
    [
      ["4,6,2,3/3", "TBD"],
    ].each do |src, expected|
      actual = solve( src )
      assert_equal actual, expected, "src=#{src}"
    end
  end
end

