# frozen_string_literal: true

require 'minitest/autorun'
require 'benchmark'
require_relative "solver"
require_relative "solve_slow"
require_relative "testcase"

class SolverTest < Minitest::Test
  def setup
    @slow_ticks = 0
    @prod_ticks = 0
  end

  def teardown
    puts( "slow: %g[sec], prod: %g[sec]" % [ @slow_ticks, @prod_ticks ] )
  end

  def test_samples
    TESTCASES.each do |src|
      expected = nil
      actual = nil
      @slow_ticks += Benchmark.realtime{ expected = solve_slow(src) }
      @prod_ticks += Benchmark.realtime{ actual = solve( src ) }
      assert_equal expected, actual, "src=#{src}"
    end
  end
end
