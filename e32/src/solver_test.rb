require 'minitest/autorun'
require_relative "solver"

class SolverTest < Minitest::Test
  def test_samples
    [
    ].each do |src, expected|
      actual = solve( src )
      assert_equal expected, actual, "src=#{src}"
    end
  end
end

