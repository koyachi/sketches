# -*- coding: utf-8 -*-
load 'youtubescraper.rb'
load 'flv2mp3.rb'
require 'video_info'
require 'echonest'
require 'json'
require 'pit'
require 'pp'

config = Pit.get('developer.echonest.com', :require => {
  'api_key' => 'foo bar'
})

module Echonest
  class Analysis
    def init_with_cache()
    end

    def to_json
      JSON.dump(@body)
    end
  end
end

url = 'http://www.youtube.com/watch?v=yzC4hFK5P3g'
video_info = VideoInfo.new(url)

# flvのdownload url多分すぐ変わるからscrapingと一緒にやった方がいい。ついでにstrip mp3も一緒でいいか。
# scrape&download処理同時に走りすぎないようにこれの前にリクエストキューを置くべき
# 1. scrape
format_stream_map = Scraper::Youtube.process(url)
pp format_stream_map
#q = '480p'
# mp3は240p? 480pだとm4aっぽい、でFlv2mp3対応してないかも
q = '240p'
flv_file = "tmp_#{Time.now.to_i}.flv"
flv_url = format_stream_map[q][:url]

# 2. download
system("curl -o #{flv_file} \"#{flv_url}\"")

# 3. strip mp3
Flv2mp3.process(flv_file)


# 4. upload to echonest
# 5. polling -> Echonest::ApiMethods.uploadでブロックする(ブロックするのか…)ので結果的に必要ない
# echonestのupload書き換えるのはありかなー　パッチ送るべきか。現実装でポーリング時間ながくなることがあるようならパッチするか。
echonest = Echonest(config['api_key'])
analysis = echonest.track.analysis("#{flv_file}.mp3")

# 6. store analisis data
open("#{video_info.video_id}.analysis.json", "w") do |file|
  file.write(analysis.to_json)
end

