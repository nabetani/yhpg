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

def new_rect(src)
  Rect.new(*src.chars.map{ |s| s.to_i(36) })
end

S0="6ayf/43gw/d7qq/mlop"

SAMPLES = [
  S0
] + [
].flatten.sort_by{ |x| [ (x+solve(x)).size, x ] }
