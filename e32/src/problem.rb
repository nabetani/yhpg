# frozen_string_literal: true

require_relative "solver"

EVENT_ID="E32"
REAL_Q=true # 本番 / 参考
EVENT_DATE=[2019,4,6]
EVENT_URL="https://yhpg.doorkeeper.jp/events/88379"
QIITA_URL = nil
TITLE="きれいな四角 #{EVENT_DATE.join(".")}"

def randcol
  "#%03x" % rand(0x1000)
end

S0="1ayd/b3gw/d7qq"

SAMPLES = [
  S0
] + [
].flatten.sort_by{ |x| [ (x+solve(x)).size, x ] }
