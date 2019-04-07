import cv2
import sys
import json
import numpy as np
from copy import deepcopy

WH=36

class Rect:
  def __init__(self, x, y, r, b):
    self.x = x+1
    self.y = y+1
    self.r = r+1
    self.b = b+1
  def __str__(self):
    return "%d,%d,%d,%d" % (self.x, self.y, self.r, self.b )
  def __repr(self):
    return __str__(self)

def newRect(s):
  s36 = "0123456789abcdefghijklmnopqrstuvwxyz"
  return Rect( * [s36.index(x) for x in s ] )

def findRect(field0, x, y, f):
  field = deepcopy(field0)
  h, w = field.shape[:2]
  mask = np.zeros((h + 2, w + 2), dtype=np.uint8)

  retval, filled, mask, rect = cv2.floodFill(
      field, mask, seedPoint=(x, y), newVal=f)

  filledArea = cv2.inRange(filled, f, f)
  cv2.imwrite( "hoge.png", filledArea )
  cons, _ =  cv2.findContours(filledArea, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
  box = cv2.boundingRect(cons[0])
  nonzeros = cv2.countNonZero(filledArea)
  if box[2] * box[3] == nonzeros:
    return box
  return None

def unusedColor(m):
  h, w = m.shape[:2]
  cols=set()
  for y in range(h):
    for x in range(w):
      cols.add( m[y,x][0] )
  for c in range(256):
    if not( c in cols ):
      return c

def solve(src):
  rects = [ newRect(s) for s in src.split("/") ]
  field = np.zeros((WH+1, WH+1, 1), np.uint8)
  col=128
  for r in rects:
    field[r.x:r.r, r.y:r.b]+=col
    col >>= 1
  f = unusedColor(field)
  cr=set()
  for y in range(1,WH):
    for x in range(1,WH):
      r = findRect( field, x, y, f )
      if r:
        cr.add(r)
  sizes = sorted([ r[2]*r[3] for r in cr ])
  return ",".join([str(s) for s in sizes])

with open(sys.argv[1], "r") as file:
  data = json.load(file)
  for case in data["test_data"]:
    actual = solve( case["src"] )
    ok = actual == case["expected"]
    print( ("ok" if ok else "**NG**"), case["src"], actual, case["expected"] )
