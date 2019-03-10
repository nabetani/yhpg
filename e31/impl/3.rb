# frozen_string_literal: true

require "json"

def less(x,y)
  if x.size!=y.size
    x.size < y.size
  else
    (x <=> y) < 0
  end
end

def count(b,upper,head,range)
  range.sum{ |x|
    cand = head + [x]
    if less(cand, upper)
      1+count(b, upper, cand, [x, (x+1) % b ])
    else
      0
    end
  }
end

def solve( src )
  sb, sx, sy = src.split(",")
  b = sb.to_i
  x = sx.to_i(b)
  y = (sy.to_i(b)+1)
  cx,cy = if b==2
    [x,y]
  else
    [x,y].map{ |e| count(b, e.digits(b).reverse, [], (1...b)) }
  end
  (cy-cx).to_s
end

if __FILE__==$PROGRAM_NAME
  json = File.open( ARGV[0], &:read)
  data = JSON.parse( json, symbolize_names:true )
  data[:test_data].map{ |number:, src:, expected:|
    actual = solve( src )
    (expected==actual).tap{ |ok|
      p [ (ok ? "ok" : "**NG**"), number, src, expected, actual ]
    }
  }.tap{ |r| puts( r.all? ? "everything is okay" : "something wrong" ) }
end

