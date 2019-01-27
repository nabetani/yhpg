require "pp"

class Cells
  def initialize(ws)
    @ws = ws.dup
    @cache={}
  end

  def at(y,x)
    key = (x<<32)+y
    @cache[key] ||= _at(y,x)
  end

  def _at(y,x)
    return x+1 if y<=0
    left0 = x*@ws[y]
    right0 = left0 + @ws[y]

    left = left0 / @ws[y-1]
    right = (right0-1) / @ws[y-1]

    (left..right).sum{ |xx| at(y-1,xx) } % 1000
  end
end

def solve( src )
  wss, ms = src.split("/")
  ws = wss.split(",").map(&:to_i)
  Cells.new(ws).at(ws.size-1, ms.to_i-1)
end
