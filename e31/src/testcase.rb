# frozen_string_literal: true

def random_cases
  [*2..36].map{ |b|
    Array.new(100){
      hi = rand(2..10_000)
      lo = rand(hi-1)+1
      [b, *[lo,hi].map{ |e| e.to_s(b) }].join(",")
    }
  }.flatten
end

TESTCASES = [
  "10,1,100",
  "10,100,999",
  "2,1000,11111",
  "3,1000,22222",
] + random_cases
