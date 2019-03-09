# frozen_string_literal: true

require "json"

def build_number(b, head, size, states)
  (size-1).times.with_object([head]) do |ix,o|
    p = o.last
    candidates = [ p, (p+1) % b ].sort
    o.push candidates[
      [nil, :below, :low].include?(states[ix]) ? 0 : 1
    ]
  end
end

def undigits(b,d)
  r=0
  d.reverse_each do |n|
    r*=b
    r+=n
  end
  r
end

def build_states(b, digits)
  ignore=false
  digits.each_cons(2).map{ |p,q|
    candidates = [ p, (p+1) % b ].sort
    if ignore
      nil
    elsif q<candidates[0]
      ignore=true
      :below
    elsif q==candidates[0]
      :low
    elsif q<candidates[1]
      ignore=true
      :mid
    elsif q==candidates[1]
      :high
    else
      ignore=true
      :above
    end
  }
end

def guru(b,digits)
  states = build_states(b, digits)
  above = states.index(:above)
  if above
    # 繰り上がり処理がある
    n = undigits(b,digits[0,above+1].reverse)
    d = (n+1).digits(b).reverse
    head = guru(b,d)
    num = [ head.last, (head.last+1) % b ].min
    head + [num] * (digits.size-above-1)
  else
    build_number(b, digits.first, digits.size, states)
  end
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
  sb, sx, sy = src.split(",")
  b = sb.to_i
  if b==2
    (sy.to_i(2) - sx.to_i(2)+1).to_s
  else
    solve_impl( b, sx.to_i(b), sy.to_i(b) ).to_s
  end
end

if __FILE__==$PROGRAM_NAME
  json = JSON.parse( File.open( "../page/data.json" ){ |f| f.read }, symbolize_names:true )
  json[:test_data].each do |number:, src:, expected:|
    actual = solve( src )
    p [ (expected==actual ? "ok" : "**NG**"), number, src, expected, actual ]
  end
end
