# frozen_string_literal: true

require 'bundler/setup'
require "net/http"
require "json"
require "nokogiri"
require "pry"

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

def doorkeeper_participants(src)
  doc = Nokogiri::HTML.parse(src.force_encoding("utf-8"), nil, 'utf-8')
  doc.xpath("//div[@class='member-name']//span").map(&:text)
end

def doorkeeper_place(src)
  re = %r!\'community\-event\-venue\-name\'\>\s*(\<[^\<\>]+\>)?\s*([^\<\>]+)\s*\<!
  re.match(src)[2].force_encoding("utf-8").strip
end

def doorkeeper( path )
  upa = URI.parse(path.gsub( "http:", "https:" ).strip + "/participants")
  src_pa = Net::HTTP.get( upa )

  u = URI.parse(path.gsub( "http:", "https:" ).strip)
  src = Net::HTTP.get( u )

  sleep(0.5)
  {
    participants:doorkeeper_participants(src_pa),
    place: doorkeeper_place(src)
  }
end

def atnd_participants(src)
  doc = Nokogiri::HTML.parse(src.force_encoding("utf-8"), nil, 'utf-8')
  doc.xpath( "//section[@id='members-join']//li//span//a" ).map{ |e| e.text }
end

def atnd_place(src)
  doc = Nokogiri::HTML.parse(src.force_encoding("utf-8"), nil, 'utf-8')
  doc.xpath("//dd[@class='location']").first.children[0].text
end

def atnd( path )
  u = URI.parse(path.gsub( "http:", "https:" ).strip)
  src = Net::HTTP.get( u )
  sleep(0.5)
  {
    participants:atnd_participants(src),
    place: atnd_place(src)
  }
end

data = []
File.open("../README.md", "r:utf-8", &:read).scan( %r!\[\s*([^\[\]]+)\s*\]\s*\(\s*(https?\:\/\/[^\(\)\s]+)! ).each do |m|
  case m[1]
  when /atnd.org/
    data.push( atnd(m[1]) )
  when /doorkeeper/
    data.push( doorkeeper(m[1]) )
  else
    puts m[1]
    next
  end
  data.last[:name] = m[0]
  puts data.last.to_json
end

File.open( "data.json", "w:utf-8" ) do |f|
  f.puts( data.to_json )
end
