#!/usr/bin/env ruby
require 'net/http'
require 'openssl'

def get_code(address,thread)
  uri = URI(address.to_s)
  http = Net::HTTP.new(uri.host, uri.port)
  if uri.scheme =='https'
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
      code = http.get(uri.request_uri).code
      puts address +" : "+ code +" : "+thread.to_s
end

@items1 = "http://3gworldagents.com"
@items2 = "http://www.google.com/"
@items3 = "https://3gworldagents.com/"

threads = (1..3).map do |i|
  Thread.new(i) do |i|
    items = instance_variable_get("@items#{i}")
    get_code(items,i)
  end
end
threads.each {|t| t.join}