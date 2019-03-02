require_relative "solver"
require_relative "solve_slow"

EVENT_ID="E31"
REAL_Q=true # 本番 / 参考
EVENT_DATE=[2019,3,9]
EVENT_URL="https://yhpg.doorkeeper.jp/events/86766"
QIITA_URL = nil
TITLE="ぐるぐる数 #{EVENT_DATE.join(".")}"

S0="4,1313,3012"

srand(0)

def gurus(src)
  sb, sx, sy = src.split(",")
  b = sb.to_i
  x, y = [sx,sy].map{ |e| e.to_i(b) }
  (x..y).select{ |e| guru?(e,b) }.map{ |e| e.to_s(b) }
end

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

def candidate(b)
  exp = rand(51)
  n=rand(2**exp)+1
  [b,n.to_s(b)].join(",")
end

def makesrc(b,lo,hi)
  [b, *[lo,hi].map{ |x| x.to_s(b) } ].join(",")
end

def find_upper(b, lo, c)
  (1..).each{ |e|
    hi=lo+2**e
    src = makesrc(b,lo,hi)
    return hi if c<solve(src).to_i
  }
end

def find_hival(b,lo,c)
  upper = find_upper( b, lo, c )
  ((lo+1)..upper).bsearch{ |hi|
    src = makesrc(b,lo,hi)
    c<=solve(src).to_i
  }
end

def rand_samples1
  rng = Random.new(1)
  d = [*2..10,*2..36].zip( [*2..850].sort_by{ rng.rand } )
  d.map{ |b,c|
    lo = rng.rand(b**3)+1
    hi = find_hival(b, lo, c)
    makesrc(b,lo,hi+rand(b**2))
  }
end

def rand_samples2
  rng = Random.new(2)
  Array.new(10){
    b = rng.rand(2..36)
    e = rng.rand(4..15)
    hi = rng.rand(2**e..2**(e+1))
    lo = rng.rand((hi/4)..(hi/2))
    makesrc(b,lo,hi)
  }
end

def zero(b,start)
  lo = start.to_i(b)
  hi = find_hival(b,lo,1)
  makesrc(b,lo,hi-1)
end

SAMPLES = [
  S0
] + [
  "2,1,1",
  "36,1,z",
  "10,100,110",
  "5,3401,40123",
  zero(36,"zoo"),
  zero(4,"1300000"),
  "2,1010010110110110000110101,11010111001011110110110101",
  "3,22111101011101,11021122211120221",
  "4,10030022033,10203020123103",
  "10,3268665,134217728",
  "36,6pku,27wr28",
  rand_samples1,
  rand_samples2,
].flatten.sort_by{ |x| [solve(x).to_i, x.size, x] }

SAMPLES.each{ |s|
  split = s.split(",")
  raise s unless split.size==3
  sb, sx, sy = split
  b = sb.to_i
  raise s unless b.to_s==sb
  raise s unless (2..36)===b
  x, y = [sx, sy].map{ |e| e.to_i(b) }
  raise s unless x.to_s(b)==sx
  raise s unless y.to_s(b)==sy
  raise s unless x<=y
  raise s unless y<=2**52
  raise s unless 0<x
}
