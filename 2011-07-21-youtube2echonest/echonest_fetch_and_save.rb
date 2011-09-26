require 'echonest'
require 'json'
require 'pp'
require 'pit'

config = Pit.get('developer.echonest.com', :require => {
  'api_key' => 'foo bar'
})

module Echonest
  class Analysis
    def to_json
      JSON.dump(@body)
    end
  end
end

flv_file = 'tmp_1312806480.flv'
echonest = Echonest(config['api_key'])
analysis = echonest.track.analysis("#{flv_file}.mp3")
#pp analysis
open("__result__.analysis.json", "w") do |file|
  file.write(analysis.to_json)
end
