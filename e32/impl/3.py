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

def findRect(field0, x, y):
  field = deepcopy(field0)
  h, w = field.shape[:2]
  mask0 = np.zeros((h + 2, w + 2, 1), dtype=np.uint8)
  _, _, mask, box = cv2.floodFill(
      field, mask0, seedPoint=(x, y), newVal=1)
  filled = mask[1:(h+1),1:(w+1)]
  if box[2] * box[3] == cv2.countNonZero(filled):
    return box, filled
  return None, filled

def buildField(src):
  field = np.zeros((WH+1, WH+1, 3), np.uint8)
  col=1
  for r in [ newRect(s) for s in src.split("/") ]:
    field[r[0]:r[2], r[1]:r[3]]+=np.array([col&255,col//256,0], np.uint8)
    col <<= 1
  return field

def collectSizes(field):
  checked = np.zeros((WH+1, WH+1, 1), np.uint8)
  sizes=[]
  for y in range(1,WH):
    for x in range(1,WH):
      if 0 != checked[y,x][0]:
        continue
      r, ch = findRect( field, x, y )
      checked += ch
      if r:
        sizes.append(r[2]*r[3])
  return sizes

def solve(src):
  field = buildField(src)
  sizes = collectSizes(field)
  return ",".join([str(s) for s in sorted(sizes)])

with open(sys.argv[1], "r") as file:
  data = json.load(file)
  for case in data["test_data"]:
    actual = solve( case["src"] )
    ok = actual == case["expected"]
    print( ("ok" if ok else "**NG**"), case["src"], actual, case["expected"] )
