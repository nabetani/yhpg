import cv2
import sys
import json
import numpy as np
from copy import deepcopy

WH=36

def newRect(s):
  s36 = "0123456789abcdefghijklmnopqrstuvwxyz"
  x, y, r, b = [s36.index(x) for x in s ]
  return (x+1, y+1, r+1, b+1)

def findRect(field0, x, y, f):
  field = deepcopy(field0)
  h, w = field.shape[:2]
  mask0 = np.zeros((h + 2, w + 2, 1), dtype=np.uint8)
  _, _, mask, box = cv2.floodFill(
      field, mask0, seedPoint=(x, y), newVal=1)
  nonzeros = cv2.countNonZero(mask[1:(h+1),1:(w+1)])
  if box[2] * box[3] == nonzeros:
    return box
  return None

def solve(src):
  rects = [ newRect(s) for s in src.split("/") ]
  field = np.zeros((WH+1, WH+1, 3), np.uint8)
  col=1
  for r in rects:
    field[r[0]:r[2], r[1]:r[3]]+=np.array([col&255,col//256,0], np.uint8)
    col <<= 1
  f = np.array([255,255,255], np.uint8)
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
