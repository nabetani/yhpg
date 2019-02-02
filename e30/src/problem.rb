require_relative "solver"

EVENT_ID="E30"
REAL_Q=true # 本番 / 参考
EVENT_DATE=[2019,2,2]
EVENT_URL="https://yhpg.doorkeeper.jp/events/84247"
QIITA_URL = nil
TITLE="面白いセルの合計 #{EVENT_DATE.join(".")}"

S0="4,6,1,5/3"

def rand_sample( len, max )
  ws = []
  while ws.size < len
    cand = rand(1..max)
    ws.push cand if ws.empty? || ws.last != cand
  end
  m = rand(1..max)
  [ws.join(","), m].join("/")
end

srand(0)

SAMPLES = [
  S0
] + [
  "1/1",
  "123/4567",
  "3,1,4,1,5,9,2/14",
  (1..16).map{ |len|
    [10,100,1000].map{ |max|
      rand_sample(len,max)
    }
  }
].flatten.sort_by{ |x| [ (x+solve(x)).size, x ] }
