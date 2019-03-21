# frozen_string_literal: true

require "pp"

FIELD_H = 36
FIELD_W = 36

HSeg = Struct.new( :y, :left, :right )

VSeg = Struct.new( :x, :top, :bottom )

Rect = Struct.new( :x, :y, :right, :bottom ) do
  def initialize( *src )
    case src.size
    when 1
      super( *src[0].chars.map{ |e| e.to_i(36) } )
    when 4
      super(*src)
    else
      raise "invalid ctor parameters:#{src.inspect}"
    end
  end

  def hsegs
    [HSeg.new( y, x, right ), HSeg.new( bottom, x, right ) ]
  end

  def vsegs
    [VSeg.new( x, y, bottom), VSeg.new( right, y, bottom ) ]
  end

  def w
    right-x
  end

  def h
    bottom-y
  end

  def size
    w*h
  end

  def include?(c)
    x<=c.x && y<=c.y && c.right<=right && c.bottom<=bottom
  end

  def no_connection?(c)
    c.right<=x || c.bottom<=y || right<=c.x || bottom<=c.y
  end

  def partial_intersect?(other)
    ! no_connection?(other) && ! other.include?(self)
  end
end

class Solver
  def initialize( rects )
    @rects = rects
    @hsegs = rects.flat_map(&:hsegs).sort_by(&:values)
    @vsegs = rects.flat_map(&:vsegs).sort_by(&:values)
  end

  def hseg_cover?(s)
    non_covered = s.left
    @hsegs.select{ |e| e.y == s.y }.each do |e|
      if e.left<=non_covered && non_covered<e.right
        non_covered = e.right
      end
    end
    s.right<=non_covered
  end

  def vseg_cover?(s)
    non_covered = s.top
    @vsegs.select{ |e| e.x == s.x }.each do |e|
      if e.top<=non_covered && non_covered<e.bottom
        non_covered = e.bottom
      end
    end
    s.bottom<=non_covered
  end

  def clean?(c)
    return false if @rects.any?{ |rc| c.partial_intersect?(rc) }
    return false unless c.hsegs.all?{ |s| hseg_cover?(s) }
    return false unless c.vsegs.all?{ |s| vseg_cover?(s) }
    true
  end

  def cleans
    ys = @hsegs.map(&:y).sort.uniq
    xs = @vsegs.map(&:x).sort.uniq
    ys.combination(2).flat_map do |t,b|
      xs.combination(2).flat_map do |l,r|
        c = Rect.new( l, t, r, b )
        clean?(c) ? [c] : []
      end
    end
  end
end

def listup( src )
  rects = src.split("/").map{ |e| Rect.new(e) }
  Solver.new( rects ).cleans
end

def solve( src )
  listup( src ).map(&:size).sort.join(",")
end
