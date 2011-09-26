# via 
# - http://www.fraction.jp/log/archives/2008/01/10/extract_mp3_from_flv_for_Ruby
# - http://sourceforge.net/projects/jtoothpaste/
# - http://jdownloader.org
module Flv2mp3
  class ::IO
    def read_ui24
      ("\000" + self.read(3)).unpack('N')[0]
    end

    alias :skip :read
  end

  class << self
    TYPE_AUDIO = [8].pack('c')
    TYPE_VIDEO = [9].pack('c')
    TYPE_SCRIPT = [18].pack('c')

    def read_header(io)
      io.skip(3 + 1 + 1 + 4)
    end

    def read_tag(io)
      io.skip(4)
      return false unless tag_type = io.read(1)

      data_size = io.read_ui24
      time_stamp = io.read_ui24
      time_stamp_extended = io.read(1).unpack('c')
      stream_id = io.read_ui24

      case tag_type
      when TYPE_AUDIO
        return audio_data(io, data_size)
        
      when TYPE_VIDEO
        io.skip(data_size)
        return true
        
      when TYPE_SCRIPT
        io.skip(data_size)
        return true
      end
    end

    def audio_data(io, size)
      io.skip(1)
      io.read(size - 1)
    end

    def process(filename)
      open(filename, 'rb') do |io|
        read_header(io)
        audio_tags = []
        while (tag = read_tag(io))
          if tag.class == String
            audio_tags.push(tag)
          end
        end
        open("#{filename}.mp3", 'wb') do |output|
          output.write(audio_tags.join(''))
        end
      end
    end
  end
end

if $0 == __FILE__
  Flv2mp3.process('yamaguchi_sanchi_no_tsutomu_kun.flv')
end

