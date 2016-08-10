#!/usr/bin/env ruby
require 'net/http'
require 'openssl'
require 'csv'

def get_code(address,thread)
  uri = URI("http://www."+address.to_s)
  http = Net::HTTP.new(uri.host, uri.port)
  httpcode = http.get(uri.request_uri).code
  uri = URI("https://www."+address.to_s)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  httpscode = http.get(uri.request_uri).code
  puts address +" : "+ httpcode +" : "+httpscode
end

@items1 = "facebook.com"
@items2 = "google.com"
@items3 = "amazon.in"
=begin
names = []
CSV.foreach("/home/xcavenger/sandbox/Ruby-Threads/top-1m.csv") do |row|
  names.push(row[1])
  puts row[1]
end
=end

threads = (1..3).map do |i|
  Thread.new(i) do |i|
    items = instance_variable_get("@items#{i}")
    get_code(items,i)
  end
end
threads.each {|t| t.join}
