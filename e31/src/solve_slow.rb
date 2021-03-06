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
  if ARGV[0]=="makesample"
    %w(
      10,123,4567
      7,123,4560
      19,123,abcd
      2,1010,10101010
      3,1010,10101010
    ).each do |src|
      puts( %Q!dataType{src:"#{src}", expected:"#{solve_slow(src)}"},! )
    end
    exit
  end
  TESTCASES.take(20).each do |src|
    _,n = src.split(",")
    puts( "%s ( %s ) -> %s" % [src, n, solve_slow(src)] )
  end
end
