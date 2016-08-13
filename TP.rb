#!/usr/bin/env ruby
require 'thread'
work_q = Queue.new

puts work_q.to_s

(0..50).to_a.each{|x| work_q.push x }
workers = (0...4).map do
  Thread.new do
    begin
      while x = work_q.pop(true)
        50.times{print [128000+x].pack "U*"}
      end
    rescue ThreadError
    end
  end
end; "ok"
workers.map(&:join); "ok"