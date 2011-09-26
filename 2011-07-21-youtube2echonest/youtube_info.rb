# -*- coding: undecided -*-
require 'video_info'
#require 'curltube'

url = 'http://www.youtube.com/watch?v=yzC4hFK5P3g'
# get video info
info = VideoInfo.new(url)
p info

# store video info
#-> mongo

# download
puts "start curltube #{url}"
system("curltube #{url}")
# -> ダメだった。jdパクんなきゃだめか。もしくは他のダウンローダ
puts "end curltube"

# convert to mp3
Flv2mp3.run("./#{info.video_id}")

# upload to echonest
#-> mongo

# polling...

# store analyzed audio data
#-> mongo

