require 'net/ftp'
require_relative '../ftp_password'

HENA='/home/nabetani/www/hena/'
DIR="orde30sumt"

src="./page"
Net::FTP.open('nabetani.sakura.ne.jp', "nabetani", FTP_PASSWORD) do |ftp|
  ftp.passive = true
  ftp.binary = true
  ftp.chdir( HENA )
  unless ftp.dir.map{ |i| i.split( /\s/ ).last }.include? DIR
    ftp.mkdir DIR
  end
  ftp.chdir DIR
  Dir.new( src ).each do |x|
    path = File.join( src, x )
    next unless File.file?( path )
    ftp.put(path, x)
    puts "#{x} was uploaded to #{path}."
  end
end
