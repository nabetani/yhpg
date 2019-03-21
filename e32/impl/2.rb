# frozen_string_literal: true

require "json"
require "pp"

FIELD_H = 36
FIELD_W = 36

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

  def w
    right-x
  end

  def h
    bottom-y
  end

  def size
    w*h
  end
end

def boundary_x_ok?(f, rc, me)
  (rc.y...rc.bottom).all? do |iy|
    me != f[pos(rc.x-1,iy)] && me != f[pos(rc.right,iy)]
  end
end

def boundary_y_ok?(f, rc, me)
  (rc.x...rc.right).all? do |ix|
    me != f[pos(ix,rc.y-1)] && me != f[pos(ix,rc.bottom)]
  end
end

def rect_at( f, x, y )
  me = f[pos(x,y)]
  return nil unless me
  right = (x..FIELD_W).find{ |e| f[pos(e,y)]!=me }
  bottom = (y..FIELD_H).find{ |e| f[pos(x,e)]!=me }
  return nil if right.nil? || bottom.nil?
  rc=Rect.new( x, y, right, bottom )
  return nil unless boundary_x_ok?(f, rc, me) && boundary_y_ok?(f, rc, me)
  filled =
  (y...bottom).all? do |iy|
    (x...right).all? do |ix|
      f[pos(ix,iy)]==me
    end
  end
  return nil unless filled
  rc
end

def fill_nil( f, rc )
  (rc.y...rc.bottom).each do |y|
    (rc.x...rc.right).each do |x|
      f[pos(x,y)] = nil
    end
  end
end

def scan_field( f )
  rects=[]
  (0...FIELD_H).each do |y|
    (0...FIELD_W).each do |x|
      rc = rect_at( f, x, y )
      next unless rc
      fill_nil( f, rc )
      rects.push rc
    end
  end
  rects
end

def pos(x,y)
  (FIELD_W+2) * (y+1) + (x+1)
end

def show(f)
  (0...(FIELD_H+2)).each do |y|
    (0...(FIELD_W+2)).each do |x|
      v=f[pos(x-1,y-1)]
      print( v ? v.to_s(36) : "*" )
    end
    puts
  end
end

def find_cleans( rects )
  field=Array.new( (FIELD_W+2)*(FIELD_H+2) ){ 0 }
  rects.each.with_index do |rc, ix|
    (rc.y...rc.bottom).each do |y|
      (rc.x...rc.right).each do |x|
        field[pos(x,y)] += 1<<ix
      end
    end
  end
  scan_field( field )
end

def listup( src )
  rects = src.split("/").map{ |e| Rect.new(e) }
  find_cleans( rects )
end

def solve( src )
  listup( src ).map(&:size).sort.join(",")
end

if __FILE__==$PROGRAM_NAME
  json = File.open( ARGV[0], &:read)
  data = JSON.parse( json, symbolize_names:true )
  data[:test_data].map{ |number:, src:, expected:|
    actual = solve( src )
    ok = expected==actual
    p [ (ok ? "ok" : "**NG**"), number, src, expected, actual ]
    ok
  }.tap{ |r| puts( r.all? ? "everything is okay" : "something wrong" ) }
end
