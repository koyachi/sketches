require 'pp'

url = 'http://www.youtube.com/watch?v=yzC4hFK5P3g'

# html5
html = `curl -H \"Cookie: f2=40000000\" #{url}`

#p html.scan(/\"fmt_list\":\s+\"(.+?)\",/)
#exit

fmt_list = {}
html.match(/\"fmt_list\":\s+\"(.+?)\",/)[1].gsub('\/', '/').split(',').map do |str|
  h = str.split('/')
  fmt_list[h[0]] = h[1]
end
p fmt_list

fmt_stream_map = {}
html.match(/\"fmt_stream_map\":\s+\"(.+?)\",/)[1].gsub('\/', '/').split(',').map do |str|
  h = str.split('|')
  resolution = fmt_list[h[0].to_s]
  q = resolution.split('x')[1].to_i
  quality = if h[0] == '40'
              '240p Light'
            elsif q > 1080
              'Original'
            elsif q > 720
              '1080p'
            elsif q > 576
              '720p'
            elsif q > 360
              '480p'
            elsif q > 240
              '360p'
            else
              '240p'
            end
  url = h[1].gsub('%2C', ',').gsub('\\u0026', '&')
  fmt_stream_map[quality] = {
    :url => url,
    :quality => quality,
    :resolution => resolution
  }
end
pp fmt_stream_map

