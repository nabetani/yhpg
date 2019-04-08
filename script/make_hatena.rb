# frozen_string_literal: true

require "net/http"

def hatena( t )
  m=/^\s*\[(.*)\]\((.*)\)\s*$/.match(t)
  if m
    name, link = [m[1], m[2]].map(&:strip)
    "[#{link}:title=#{name}]"
  else
    t
  end
end

def date( t )
  link=/^\s*\[(.*)\]\((.*)\)\s*$/.match(t)[2]
  if /atnd\.org/===link
    u = URI.parse(link.gsub( "http:", "https:" ).strip)
    src = Net::HTTP.get( u )
    m=%r!\<dd\>(\d+)\/(\d+)\/(\d+)!.match(src)
    yy,mm,dd = [m[1],m[2],m[3]].map( &:to_i )
    sleep(0.5)
    "%d年%d月%d日" % [ yy, mm, dd ]
  else
    u = URI.parse(link.gsub( "http:", "https:" ).strip)
    src = Net::HTTP.get( u )
    m=/\<date class\=\'community\-event\-info\-date\'\>(\d+)\-(\d+)\-(\d+)/.match(src)
    yy,mm,dd = [m[1],m[2],m[3]].map( &:to_i )
    sleep(0.5)
    "%d年%d月%d日" % [ yy, mm, dd ]
  end
end

puts DATA.read.strip
File.open("../README.md", &:read).scan( /^\s*\|\s*\[[^\r\n]*\|\s*$/ ).each do |m|
  ev, q0, q1, qer = m.split("|").select{ |e| !e.empty? }.map(&:strip)
  # puts "|*#{hatena(ev)}|#{date(ev)}|"
  if q0 != "n/a"
    puts "|#{hatena(ev)} - 参考問題|#{hatena(q0)}|#{qer}|"
  end
  puts "|#{hatena(ev)} - 当日の問題|#{hatena(q1)}|#{qer}|"
end

__END__

|*イベント - 種別|*問題|*問題作成者(敬称略)|