#!/usr/bin/env ruby
#
# USAGE:
#   ruby emsynchronied_fetcher.rb $(cat urls.txt)
#
require 'em-synchrony'
require 'em-synchrony/em-http'

urls = ARGV
if urls.size < 1
  puts "Usage: #{$0} <url> <url> <...>"
  exit
end

EM.synchrony do
  concurrency = 2
  results = EM::Synchrony::Iterator.new(urls, concurrency).map do |url, iter|
    puts "# start ... #{url}"
    http = EM::HttpRequest.new(url).aget
    http.callback { iter.return(http) }
    http.errback { iter.return(http) }
  end
  results.each do |result|
    puts "#{result.req.uri}\n#{result.response_header.status} - #{result.response.length} bytes\n"
  end
  EM.stop
end
