require_relative "solver"

EVENT_ID="E31"
REAL_Q=true # 本番 / 参考
EVENT_DATE=[2019,3,9]
EVENT_URL="https://yhpg.doorkeeper.jp/events/86766"
QIITA_URL = nil
TITLE="ぐるぐる数 #{EVENT_DATE.join(".")}"

S0="4,6,1,5/3"

srand(0)

def make_guru(b, len)
  f=lambda do
    s=(rand(b-1)+1).to_s(b)
    (len-1).times do
      s+=rand(2).zero? ? s[-1] : ((s[-1].to_i(b)+1)%b).to_s(b)
    end
    s
  end
  [b, f[] ]
end

def make_no_guru(b, len)
  pos = rand(len-1)
  f=lambda do
    s=(rand(b-1)+1).to_s(b)
    (len-1).times do |ix|
      if ix==pos
        candidates = [*0...b] - [0,1].map{ |d| ( s[-1].to_i + d ) % b }
        s+= candidates.sample.to_s(b)
      else
        s+=rand(2).zero? ? s[-1] : ((s[-1].to_i(b)+1)%b).to_s(b)
      end
    end
    s
  end
  [b, f[] ]
end

def guru_string?(b,s)
  s.squeeze.chars.map{ |c| c.to_i(b) }.each_cons(2).all?{ |p,q|
    (p+1) % b==q
  }
end

NUMSAMPLES = [
  make_guru(10,1),
  make_guru(2,10),
  make_guru(3,5),
  make_guru(4,8),
  make_guru(10,20),
  make_guru(16,3),
  make_guru(36,2),
  make_no_guru(10,2),
  make_no_guru(3,5),
  make_no_guru(4,8),
  make_no_guru(10,20),
  make_no_guru(16,3),
  make_no_guru(36,2),
]

SAMPLES = [
  S0
] + [
]