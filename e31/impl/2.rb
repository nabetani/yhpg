# frozen_string_literal: true

require "json"

def state(b, x)
  x.each_cons(2).map{ |prev,cur|
    lambda{ |lo,hi|
      return :below if cur<lo
      return :lo if cur==lo
      return :mid if cur<hi
      return :hi if cur==hi
      return :above
    }[*[ prev, (prev+1) % b ].sort]
  }
end

def count_state( s )
  return 1 if s.empty?
  case s[0]
  when :below then 0
  when :lo then count_state(s.drop(1))
  when :mid then 2**(s.size-1)
  when :hi then count_state(s.drop(1)) + 2**(s.size-1)
  when :above then 2**s.size
  end
end

# x 以下の ぐるぐる数の個数
def guru_count( b, x )
  # x.size 未満の桁数
  s0 = (1...x.size).sum{ |keta| (b-1)*(2**(keta-1)) }
  # x.size 桁で、先頭が 1..(x.first-1)
  s1 = (x.first-1)*(2**(x.size-1))
  # 先頭が x.first
  s2 = count_state( state(b, x) )
  [s0, s1, s2].sum
end

def solve( src )
  sb,sx,sy = src.split(",")
  b = sb.to_i
  x = (sx.to_i(b) - 1).digits(b).reverse
  y = sy.to_i(b).digits(b).reverse
  ycount = guru_count(b,y)
  xcount = guru_count(b,x)
  ( ycount - xcount ).to_s
end

if __FILE__==$PROGRAM_NAME
  json = File.open( ARGV[0], &:read)
  data = JSON.parse( json, symbolize_names:true )
  data[:test_data].map{ |number:, src:, expected:|
    actual = solve( src )
    ok = expected==actual
    p [ (ok ? "ok" : "**NG**"), number, src, expected, actual ]
    ok
  }.tap{ |r| puts( r.all? ? "everything is okay" : "something wrong" ) }
end
