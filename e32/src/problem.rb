require_relative "solver"

EVENT_ID="E32"
REAL_Q=true # 本番 / 参考
EVENT_DATE=[2019,4,6]
EVENT_URL="https://yhpg.doorkeeper.jp/events/88379"
QIITA_URL = nil
TITLE="きれいな四角 #{EVENT_DATE.join(".")}"

S0="11,22,33,44/55,66,77,88"

Rect = Struct.new( :x, :y, :right, :bottom ) do
  def initialize( *src )
    case src.size
    when 1
      super( *src[0].split(",").map(&:to_i) )
    when 4
      super(*src)
    end
  end

  def w
    bottom-y
  end

  def h
    right-x
  end
end

SAMPLES = [
  S0
] + [
].flatten.sort_by{ |x| [ (x+solve(x)).size, x ] }
