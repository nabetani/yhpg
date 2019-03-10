# frozen_string_literal: true

require "json"

def next_vals(b,n)
  [n, (n+1)%b]
end

def build_number(b, head, size, states)
  (size-1).times.with_object([head]) do |ix,o|
    candidates = next_vals(b, o.last).sort
    o.push candidates[:low==states[ix] ? 0 : 1]
  end
end

def undigits(b,d)
  d.reverse_each.inject(0) do |acc,n|
    acc*b+n
  end
end

def build_states(b, digits)
  r=digits.each_cons(2).with_object([]){ |(p,q),o|
    candidates = next_vals( b, p )
    o << %i(low high above)[candidates.count{ |e| e<q }]
    break o unless candidates.include?(q)
  }
  r + [:low]*(digits.size-1-r.size)
end

def guru(b,digits)
  states = build_states(b, digits)
  above = states.index(:above)
  return build_number(b, digits.first, digits.size, states) unless above
  # 繰り上がり処理がある
  n = undigits(b,digits[0,above+1].reverse)
  d = (n+1).digits(b).reverse
  head = guru(b,d)
  head + [next_vals( b, head.last).min] * (digits.size-above-1)
end

def sup(b,x)
  undigits(b, guru(b, x.digits(b).reverse).reverse)
end

def solve_impl( b, x, y )
  x = sup(b,x)
  count = 0
  while x<=y
    count+=1
    x = sup(b,x+1)
  end
  count
end

def solve( src )
  sb, *sxy = src.split(",")
  b = sb.to_i
  xy = sxy.map{ |e| e.to_i(b) }
  if b==2
    (xy[1] - xy[0]+1).to_s
  else
    solve_impl( b, *xy ).to_s
  end
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
