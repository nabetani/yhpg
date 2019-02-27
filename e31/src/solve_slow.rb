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
  sb, n = src.split(",")
  b = sb.to_i
  solve_slow_impl( b, n.to_i(b))
end

if __FILE__==$PROGRAM_NAME
  TESTCASES.each do |src|
    _,n = src.split(",")
    puts( "%s ( %s ) -> %s" % [src, n, solve_slow(src)] )
  end
end
