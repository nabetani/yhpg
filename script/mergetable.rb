# frozen_string_literal: true

require "json"
require "pp"

def read_table
  src = File.open( "hatena2019.04.07.txt", "r:utf-8", &:read )
  src.split(/[\r\n]+/)
  .select{ |x| x.start_with?("|*[" ) }
  .map{ |e|
    m=%r!\|\*\[([^\[\]]+)\:title\=([^\[\]]+)\]\|(.*)\|!.match(e)
    [m[2], { url:m[1], date:m[3]}]
  }.to_h
end

data = JSON.parse( File.open( "data.json", "r:utf-8", &:read ) )
table = read_table
data.each do |d|
  name = d["name"]
  d["url"] = table[name][:url]
  d["date"] = table[name][:date]
end

File.open( "data.json", "w:utf-8" ) do |f|
  f.puts( data.to_json )
end
