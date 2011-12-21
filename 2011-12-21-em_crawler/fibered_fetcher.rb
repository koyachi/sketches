#!/usr/bin/env ruby
#
# USAGE:
#   ruby fibered_fetcher.rb $(cat urls.txt)
#
require 'eventmachine'
require 'em-http-request'
require 'fiber'

urls = ARGV
if urls.size < 1
  puts "Usage: #{$0} <url> <url> <...>"
  exit
end

def async_fetch(url)
  f = Fiber.current
  http = EM::HttpRequest.new(url).get :timeout => 10
  http.callback { f.resume(http) }
  http.errback { f.resume(http) }

  Fiber.yield
  
  if http.error
    p [:HTTP+ERROR, http.error]
  end

  http
end

EM.run do
  # serialized requests...
  Fiber.new {
    urls.each do |url|
      puts "# start ... #{url}"
      data = async_fetch(url)
      puts "#{url}\n#{data.response_header.status} - #{data.response.length} bytes\n"
    end
    EM.stop
  }.resume
end

puts "Done"
