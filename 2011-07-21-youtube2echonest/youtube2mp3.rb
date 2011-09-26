
module Youtube2mp3
  class << self
    def normalize_youtube_url(url)
      url
    end

    def convert_url(url)
      normalized_url = normalize_youtube_url(url)
    end

    def download_mp3(url)
    end

    def run(youtube_url)
      download_mp3(convert_url(youtube_url))
    end
  end
end

puts Youtube2mp3.convert_url("http://www.youtube.com/watch?v=yzC4hFK5P3g")
#Youtube2mp3.run()
