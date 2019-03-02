# frozen_string_literal: true

require_relative "testcase"

def guru?(x,b)
  x.digits(b).each_cons(2).all?{ |p,q|
    p==q || p==(q+1)%b
  }
end

def solve_slow_impl( b, x, y )
  (x..y).count{ |e|
    guru?(e,b)
  }
end

def solve_slow(src)
  sb, sx, sy = src.split(",")
  b = sb.to_i
  x, y = [sx,sy].map{ |e| e.to_i(b) }
  solve_slow_impl( b, x, y ).to_s
end

if __FILE__==$PROGRAM_NAME
  TESTCASES.take(20).each do |src|
    _,n = src.split(",")
    puts( "%s ( %s ) -> %s" % [src, n, solve_slow(src)] )
  end
end
