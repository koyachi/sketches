# via jdownloader/trunk/src/jd/plugins/decrypter/TbCm.java
require 'uri'

module Scraper
  module Youtube
    class << self
      def process(url)
        # html5
        html = `curl -H \"Cookie: f2=40000000\" '#{url}'`
        self.format_stream_map(html)
      end

      def format_list(html)
        format_list = {}
        html.match(/\"fmt_list\":\s+\"(.+?)\",/)[1].gsub('\/', '/').split(',').map do |str|
          h = str.split('/')
          format_list[h[0]] = h[1]
        end
        format_list
      end

      def format_stream_map(html)
        format_stream_map = {}
        html.match(/\"url_encoded_fmt_stream_map\":\s+\"(.+?)\",/)[1].gsub('\/', '/').split(',').map do |str|
          url = URI.unescape(str[4..-1].gsub('\\u0026', '&').match(/(http.*?)&/)[1])
          tag = str.split('\u0026itag=')[1]
          resolution = self.format_list(html)[tag]
          q = resolution.split('x')[1].to_i
          quality = if tag == '40'
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
          format_stream_map[quality] = {
            :url => url,
            :quality => quality,
            :q => q,
            :resolution => resolution,
            :tag => tag,
          }
        end
        format_stream_map
      end
    end
  end
end

if $0 == __FILE__
  require 'pp'
  format_stream_map = Scraper::Youtube.process('http://www.youtube.com/watch?v=yzC4hFK5P3g')
  pp format_stream_map
end

