require "json"

class Cells
  def initialize(ws)
    @ws = ws.dup
    @cache={}
  end

  def at(y,x)
    key = (x<<32)+y
    @cache[key] ||= _at(y,x)
  end

  def interesting?(y,x)
    !( 0<y && at(y,x)==at(y,x-1) && at(y,x)==at(y,x+1) )
  end

  def _at(y,x)
    return x+1 if y<=0
    left0 = x*@ws[y]
    right0 = left0 + @ws[y]

    left = left0 / @ws[y-1]
    right = (right0-1) / @ws[y-1]

    (left..right).select{ |xx|
      interesting?(y-1,xx)
    }.sum{ |xx| 
      at(y-1,xx)
    } % 1000
  end
end

def solve( src )
  wss, ms = src.split("/")
  ws = wss.split(",").map(&:to_i)
  Cells.new(ws).at(ws.size-1, ms.to_i-1).to_s
end

if $0==__FILE__
  data = JSON.parse(DATA.read, symbolize_names: true)
  data[:test_data].map{ | number:, src:, expected: |
    actual = solve( src )
    okay = actual == expected
    puts [ number, (okay ? "ok" : "**NG**"), actual, expected ].join(" ")
    okay
  }.all?.yield_self{ |x| puts( x ? "okay" : "SOMETHING WRONG" ) }
end

__END__
{"event_id":"E30","event_url":"https://yhpg.doorkeeper.jp/events/84247","test_data":[
  {"number":0,"src":"4,6,1,5/3","expected":"14"},
  {"number":1,"src":"1/1","expected":"1"},
  {"number":2,"src":"6/1","expected":"1"},
  {"number":3,"src":"4,6/3","expected":"9"},
  {"number":4,"src":"68/68","expected":"68"},
  {"number":5,"src":"360/10","expected":"10"},
  {"number":6,"src":"2,7,8/8","expected":"256"},
  {"number":7,"src":"37,88/71","expected":"504"},
  {"number":8,"src":"5,4,1,4/6","expected":"10"},
  {"number":9,"src":"123/4567","expected":"4567"},
  {"number":10,"src":"473,601/397","expected":"9"},
  {"number":11,"src":"47,89,82/38","expected":"402"},
  {"number":12,"src":"4,8,1,2,10/10","expected":"98"},
  {"number":13,"src":"5,6,7,9,5,2/5","expected":"48"},
  {"number":14,"src":"538,846,73/778","expected":"213"},
  {"number":15,"src":"80,48,65,83/100","expected":"830"},
  {"number":16,"src":"1,4,6,10,5,7,5/5","expected":"904"},
  {"number":17,"src":"10,4,1,6,1,2,3,5/3","expected":"9"},
  {"number":18,"src":"3,1,4,1,5,9,2/14","expected":"385"},
  {"number":19,"src":"33,32,75,24,36/76","expected":"491"},
  {"number":20,"src":"43,59,32,2,66,42/58","expected":"849"},
  {"number":21,"src":"985,178,756,798/660","expected":"675"},
  {"number":22,"src":"3,4,3,4,5,2,3,10,2/5","expected":"334"},
  {"number":23,"src":"9,3,4,3,1,9,4,9,3,9/5","expected":"516"},
  {"number":24,"src":"883,184,29,803,129/129","expected":"154"},
  {"number":25,"src":"4,77,53,79,16,21,100/59","expected":"690"},
  {"number":26,"src":"49,94,4,99,43,78,22,74/1","expected":"282"},
  {"number":27,"src":"292,871,120,780,431,83/92","expected":"396"},
  {"number":28,"src":"4,2,9,1,5,10,7,6,8,9,10/3","expected":"234"},
  {"number":29,"src":"9,5,7,6,9,3,4,10,8,6,4,5/6","expected":"990"},
  {"number":30,"src":"11,87,44,12,3,52,81,33,55/1","expected":"384"},
  {"number":31,"src":"9,2,6,9,5,1,3,6,1,9,2,1,4/9","expected":"498"},
  {"number":32,"src":"68,62,15,97,5,68,12,87,78,76/57","expected":"751"},
  {"number":33,"src":"792,720,910,374,854,561,306/582","expected":"731"},
  {"number":34,"src":"5,10,1,7,5,3,5,7,4,8,9,6,1,9,6/5","expected":"768"},
  {"number":35,"src":"7,2,7,8,3,4,2,10,6,10,3,1,10,2/10","expected":"120"},
  {"number":36,"src":"4,2,10,7,8,9,8,1,9,7,9,10,9,4,7,2/8","expected":"40"},
  {"number":37,"src":"41,55,80,12,39,94,2,96,45,89,25/68","expected":"152"},
  {"number":38,"src":"907,371,556,955,384,24,700,131/378","expected":"600"},
  {"number":39,"src":"30,68,36,40,10,74,42,24,4,47,91,51/4","expected":"180"},
  {"number":40,"src":"807,276,175,555,372,185,445,489,590/287","expected":"80"},
  {"number":41,"src":"92,41,37,49,26,68,36,31,30,34,19,18,94/85","expected":"626"},
  {"number":42,"src":"529,153,926,150,111,26,465,957,890,887/118","expected":"114"},
  {"number":43,"src":"59,1,87,64,17,37,95,25,64,68,52,9,57,92/94","expected":"998"},
  {"number":44,"src":"979,772,235,717,999,292,727,702,710,728,556/33","expected":"912"},
  {"number":45,"src":"40,93,46,27,75,53,50,92,52,100,19,35,52,31,54/59","expected":"512"},
  {"number":46,"src":"800,778,395,540,430,200,424,62,342,866,45,803/931","expected":"260"},
  {"number":47,"src":"85,90,67,61,17,57,24,25,5,50,88,31,55,26,21,98/58","expected":"884"},
  {"number":48,"src":"510,515,70,358,909,557,886,766,323,624,92,342,424/552","expected":"238"},
  {"number":49,"src":"892,751,88,161,148,585,456,88,14,315,594,121,885,952/833","expected":"700"},
  {"number":50,"src":"940,824,509,787,942,856,450,327,491,54,817,95,60,337,667/637","expected":"206"},
  {"number":51,"src":"408,412,30,930,372,822,632,948,855,503,8,618,138,695,897,852/377","expected":"212"}
]}
