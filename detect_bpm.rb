require 'rubygems'
require 'soundtouch'
require 'wav-file'

#read file
f = open(ARGV.shift)
fmt, chunks = WavFile::readAll(f)
f.close

puts fmt

bpm_detector = Soundtouch::BPMDetect.new(fmt.channel, fmt.hz)

read_upto = 0
max_read_limit = chunks[0].data.size
buffer_count = 0
buf = Array.new(4096)
while max_read_limit > (read_upto + 4096)
	buf.clear
	buf = chunks[0].data.slice(read_upto, read_upto + 4096)
	float_buf = buf.unpack('f1024')
	buffer_count += 1
	bpm_detector.inputSamples(float_buf, 1024)
	read_upto += 4096
	print '.'
end
puts "\nread #{buffer_count} buffers"
bpm = bpm_detector.getBpm()
puts "BPM = #{bpm}"

#buf = chunks[0].data.slice(0,4096)
#float_buf = buf.unpack('f1024')
#puts "size of float_buf = #{float_buf.length}"

#run putSample
#puts "SoundTouch version = #{Soundtouch::SoundTouch.getVersionString()}"
#(0..4).each { |i|
#	index = Random.rand(1024)
#	puts "float_buf[#{index}] = #{float_buf[index]} (#{float_buf[index].class.name})"
#}

#bpm_detector.inputSamples(float_buf, 1024)
#bpm = bpm_detector.getBpm()
#puts "BPM = #{bpm}"
