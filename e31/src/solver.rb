# frozen_string_literal: true

DIGITS=[*"0".."9", *"a".."z"]

def number(r)
  r.map{ |e| DIGITS[e] }.join
end

def build_number(b, head, size, states)
  r=[head]
  (size-1).times do |ix|
    p = r.last
    candidates = [ p, (p+1) % b ].sort
    r.push candidates[
      [nil, :below, :low].include?(states[ix]) ? 0 : 1
    ]
  end
  r
end

def undigits(b,d)
  r=0
  d.reverse.each do |n|
    r*=b
    r+=n
  end
  r
end

def solve_impl(b,digits)
  ignore=false
  states = digits.each_cons(2).map{ |p,q|
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
  above = states.index(:above)
  if above
    n = undigits(b,digits[0,above+1].reverse)
    d = (n+1).digits(b).reverse
    head = solve_impl(b,d)
    num = [ head.last, (head.last+1) % b ].min
    tail = [num] * (digits.size-above-1)
    head+tail
  else
    build_number(b, digits.first, digits.size, states)
  end
end

def solve( src )
  sb,n = src.split(",")
  b = sb.to_i
  digits = (n.to_i(b)+1).digits(b).reverse
  solve_impl(b, digits).map{ |e| DIGITS[e] }.join
end

if __FILE__==$PROGRAM_NAME
  [ "4,828" ].each do |src|
    b,n = src.split(",").map(&:to_i)
    digit = n.to_s(b)
    puts( "%s ( %s ) -> %s" % [src, digit, solve(src)] )
  end
end
