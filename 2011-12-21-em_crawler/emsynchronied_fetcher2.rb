#!/usr/bin/env ruby
#
# USAGE:
#   ruby emsynchronied_fetcher2.rb $(cat urls.txt)
#
require 'em-synchrony'
require 'em-synchrony/em-http'
require 'em-synchrony/fiber_iterator'

urls = ARGV
if urls.size < 1
  puts "Usage: #{$0} <url> <url> <...>"
  exit
end

EM.synchrony do
  concurrency = 2
  EM::Synchrony::FiberIterator.new(urls, concurrency).map do |url, iter|
    puts "# start ... #{url}"
    http = EM::HttpRequest.new(url).get
    puts "#{url}\n#{http.response_header.status} - #{http.response.length} bytes\n"
  end
  EM.stop
end
