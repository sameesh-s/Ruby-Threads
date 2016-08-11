#!/usr/bin/env ruby
require 'net/http'
require 'openssl'
require 'thread'

def write(arr)
  CSV.open("myfile.csv","a") do |csv|
    csv <<arr
  end
end

def get_code(address)
  uri =URI(address.to_s)
  http = Net::HTTP.new(uri.host, uri.port)
  if uri.scheme == "https"
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end 
  return http.get(uri.request_uri).code   
end

def get_row(address,index)
  arr = []
  arr.push(index.to_i)
  arr.push(address.to_s)
  arr.push(get_code("http://www."+address.to_s))
  arr.push(get_code("https://www."+address.to_s))
  arr
end

@address1 = "flipkart.com"
@address2 = "google.com"
@address3 = "amazon.in"

names=[]
names=File.read("/home/xcavenger/sandbox/Ruby-Threads/test.csv").split.map{|i| i.split(",").last}
#puts names

mutex = Mutex.new
cv = ConditionVariable.new

threads = (1..3).map do |i|
  Thread.new(i) do |i|
    address = instance_variable_get("@address#{i}")
    arr = get_row(address,i)
    mutex.synchronize do
      write(arr)
      end
  end
end
threads.each {|t| t.join}
threads.each {|t| puts t.stop?}
