# frozen_string_literal: true

require 'minitest/autorun'
require_relative "solver"

def guru?(x,b)
  x.digits(b).each_cons(2).all?{ |p,q|
    p==q || p==(q+1)%b
  }
end

def solve_slow_impl( b, n )
  ((n+1)..).find{ |x|
    guru?(x,b)
  }.to_s(b)
end

def solve_slow(src)
  solve_slow_impl( *src.split(",").map(&:to_i) )
end

class SolverTest < Minitest::Test
  def test_samples
    [
      "10,100",
      "10,122",
      "10,123",
      "10,123",
    ].each do |src|
      expected = solve_slow(src)
      actual = solve( src )
      assert_equal expected, actual, "src=#{src}"
    end
  end
end
