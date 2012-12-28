require 'rubygems'
require 'soundtouch'
require 'wav-file'

#read file
f = open(ARGV.shift)
fmt, chunks = WavFile::readAll(f)
f.close

#get the first sample buffer
buf = chunks[0].data.slice(0,4096)
float_buf = buf.unpack('f1024')
puts "size of float_buf = #{float_buf.length}"

#run putSample
puts "SoundTouch version = #{Soundtouch::SoundTouch.getVersionString()}"
(0..4).each { |i|
	index = Random.rand(1024)
	puts "float_buf[#{index}] = #{float_buf[index]} (#{float_buf[index].class.name})"
}
s = Soundtouch::SoundTouch.new
s.setSampleRate(fmt.hz)
s.setChannels(fmt.channel)
s.putSamples(float_buf, 1024)
