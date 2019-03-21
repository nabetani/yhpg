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

def make(s)
  r = s.split("/").map{ |e| 
    e.chars.map{|c| c.to_i(36) }
    .each_slice(2)
    .map{ |c| Complex(*c) } 
  }
  xs = r.flatten.map(&:real).uniq.sort
  ys = r.flatten.map(&:imag).uniq.sort
  xv = [*0...FIELD_W].sample(xs.size).sort.map{ |e| e.to_s(36) }
  yv = [*0...FIELD_H].sample(ys.size).sort.map{ |e| e.to_s(36) }
  xh = Hash[xs.zip(xv)]
  yh = Hash[ys.zip(yv)]
  r.map{ |e|
    [ xh[e[0].real], yh[e[0].imag], xh[e[1].real], yh[e[1].imag] ].join
  }.join("/")
end

class Rect
  def center
    (x+w/2.0) + (y+h/2.0)*1i
  end
end

def rand_sample(s,v)
  Array.new(s*2){
    xs = [*1..v].sample(2).sort
    ys = [*1..v].sample(2).sort
    xs.zip(ys).flatten.map{ |e| e.to_s(36) }.join
  }.uniq.take(s).join("/")
end

srand(0)
SAMPLES = [
  S0,
] + [
  "00ab/p0zd/0ofz/87rs",
  %w(
    1122
    1144/2233
    2143/1234
    2132/3243/1223/2334
    1143/2132/2233
    2245/1334/3154
    1a2b/3a4b/1c2d/3c4d
    1133/4153/2266/1435/4455
    1123/2133/1132/1233
    2144/3255/1346
    2143/4264/3466/1335
    3164/5387/1246/2578
    2132/1223/4152/5263/1425/2536/4556/5465
  ).map{ |e| make(e) },
  [*3..8].map{ |size|
    [4, 6, 8, 12, 36].map{ |v|
      make(rand_sample(size,v))
    }
  }
].flatten.sort_by{ |x| [ (x+solve(x)).size, x ] }
