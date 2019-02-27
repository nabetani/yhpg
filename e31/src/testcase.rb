# frozen_string_literal: true

def random_cases
  [*2..36].map{ |b|
    [*1..50000].shuffle.take(100).map{ |n| [b,n.to_s(b)].join(",") }
  }.flatten
end

TESTCASES = [
  "10,123123",
  "10,100",
  "10,122",
  "10,123",
  "10,124",
  "10,998",
  "10,999",
  "10,1122",
  "10,1234",
  "10,789",
  "2,1010",
  "4,30330",
] + random_cases
