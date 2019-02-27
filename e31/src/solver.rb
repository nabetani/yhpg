# frozen_string_literal: true

require "pp"

DIGITS=[*"0".."9", *"a".."z"]

def number(r)
  r.map{ |e| DIGITS[e] }.join
end

def build_number(b, head, size, states)
  r=[head]
  (size-1).times do |ix|
    p = r.last
    candidates = [ p, (p+1) % b ].sort
    r.push case states[ix]
    when nil
      candidates[0]
    when :below
      candidates[0]
    when :low
      candidates[0]
    when :mid
      candidates[1]
    when :high
      candidates[1]
    when :above
      raise( "unexpected" )
    end
  end
  number(r)
end

def lowest_guru(b,len,head)
  if head==b
    "1"*(len+1)
  else
    DIGITS[head+1]*len
  end
end

def solve_impl(b,n)
  n+=1
  digits = n.digits(b).reverse
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
  if states.include?(:above)
    lowest_guru(b, digits.size, digits.first)
  else
    build_number(b, digits.first, digits.size, states)
  end
end

def solve( src )
  solve_impl(*src.split(",").map(&:to_i))
end
