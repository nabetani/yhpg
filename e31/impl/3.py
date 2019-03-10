import json
import sys

def digits(b,x):
  r=[]
  while True:
    if x==0:
      return r
    r.insert(0, x % b)
    x //= b

def less( a, b ):
  if len(a) != len(b):
    return len(a)<len(b)
  return a<b

def impl( b, upper, head, nextnums ):
  sum=0
  for x in nextnums:
    cand = head + [x]
    if less(cand, upper):
      sum+=1+impl(b, upper, cand, [x, (x+1) % b] )
  return sum

def count(b,x):
  if b==2:
    return x
  return impl( b, digits(b,x), [], range(1,b) )

def solve( src ):
  s=src.split(",")
  b = int(s[0])
  x = int(s[1],b)
  y = int(s[2],b)+1
  cx,cy = [ count(b,s) for s in [x,y] ]
  return str(cy-cx)

with open(sys.argv[1], "r") as file:
  data = json.load(file)
  for case in data["test_data"]:
    actual = solve( case["src"] )
    ok = actual == case["expected"]
    print( ("ok" if ok else "**NG**"), case["src"], actual, case["expected"] )
