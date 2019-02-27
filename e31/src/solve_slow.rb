# frozen_string_literal: true

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
    b,n = src.split(",").map(&:to_i)
    digit = n.to_s(b)
    puts( "%s ( %s ) -> %s" % [src, digit, solve_slow(src)] )
  end
end
