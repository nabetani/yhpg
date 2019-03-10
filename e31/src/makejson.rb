require_relative "problem"
require "json"

s=SAMPLES.map.with_index{ |m,ix|
  {number:ix, src:m, expected:solve(m) }
}

puts( {
  event_id: EVENT_ID,
  event_url: EVENT_URL,
  test_data: s
}.to_json )
