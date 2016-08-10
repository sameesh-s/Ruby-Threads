#!/usr/bin/env ruby

threads = []
threads << Thread.new { puts "first thread" }
threads << Thread.new { puts "second thread" }
threads << Thread.new {3.times {puts "3 times looping thread"} }
threads << Thread.new { puts "forth thread" }

threads.each { |thr| thr.join }