require_relative "solver"

EVENT_ID="E30"
REAL_Q=true # 本番 / 参考
EVENT_DATE=[2019,2,2]
EVENT_URL="https://yhpg.doorkeeper.jp/events/84247"
QIITA_URL = nil
TITLE="上段の矩形の和 #{EVENT_DATE.join(".")}"

S0="4,6,1,5/2"

SAMPLES = [
  S0
] + [
].flatten.sort_by{ |x| [ (x+solve(s)).size, x ] }


