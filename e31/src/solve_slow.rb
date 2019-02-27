# frozen_string_literal: true

require_relative "testcase"

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

if __FILE__==$PROGRAM_NAME
  TESTCASES.each do |src|
    b,n = src.split(",").map(&:to_i)
    digit = n.to_s(b)
    puts( "%s ( %s ) -> %s" % [src, digit, solve_slow(src)] )
  end
end
