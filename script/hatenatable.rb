# frozen_string_literal: true
require "json"


puts( "|*イベント|*開催日|*会場|" )

JSON.parse( File.open( "data.json", "r:utf-8", &:read ) ).each do |s|
  #|*[http://atnd.org/events/30285:title=第一回]|2012年7月6日|
  puts( "|*[#{s["url"]}:title=#{s["name"]}]|#{s["date"]}|#{s["place"].gsub( "&amp;", "&")}|" )
end
