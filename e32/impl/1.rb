# frozen_string_literal: true

require "json"

Seg = Struct.new( :level, :lo, :hi )

Rect = Struct.new( :x, :y, :right, :bottom ) do
  def hsegs
    [Seg.new( y, x, right ), Seg.new( bottom, x, right ) ]
  end

  def vsegs
    [Seg.new( x, y, bottom), Seg.new( right, y, bottom ) ]
  end

  def size
    (right-x)*(bottom-y)
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

  def seg_cover?(s, segs)
    non_covered = s.lo
    segs.select{ |e| e.level == s.level }.each do |e|
      non_covered = e.hi if e.lo<=non_covered && non_covered<e.hi
    end
    s.hi<=non_covered
  end

  def clean?(c)
    return false if @rects.any?{ |rc| c.partial_intersect?(rc) }
    return false unless c.hsegs.all?{ |s| seg_cover?(s, @hsegs) }
    return false unless c.vsegs.all?{ |s| seg_cover?(s, @vsegs) }
    true
  end

  def cleans
    ys = @hsegs.map(&:level).sort.uniq
    xs = @vsegs.map(&:level).sort.uniq
    ys.combination(2).flat_map do |t,b|
      xs.combination(2).flat_map do |l,r|
        c = Rect.new( l, t, r, b )
        clean?(c) ? [c] : []
      end
    end
  end
end

def solve( src )
  rects = src.split("/").map{ |e| Rect.new(*e.chars.map{ |s| s.to_i(36) }) }
  cleans = Solver.new( rects ).cleans
  cleans.map(&:size).sort.join(",")
end

if __FILE__==$PROGRAM_NAME
  json = File.open( ARGV[0], &:read)
  data = JSON.parse( json, symbolize_names:true )
  data[:test_data].map{ |number:, src:, expected:|
    actual = solve( src )
    (expected==actual).tap do |ok|
      p [ (ok ? "ok" : "**NG**"), number, src, expected, actual ]
    end
  }.tap{ |r| puts( r.all? ? "everything is okay" : "something wrong" ) }
end
