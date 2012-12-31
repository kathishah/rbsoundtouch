require 'rubygems'
require 'soundtouch'
require 'wav-file'

BUFF_SIZE = 2048

#read file
f = open(ARGV.shift)
fmt, chunks = WavFile::readAll(f)
f.close

puts fmt

bpm_detector = Soundtouch::BPMDetect.new(fmt.channel, fmt.hz)

read_upto = 0
max_read_limit = chunks[0].data.size
buffer_count = 0
buf = Array.new(BUFF_SIZE)
float_buf = []
while max_read_limit > (read_upto + BUFF_SIZE)
	buf.clear
	float_buf.clear
	buf = chunks[0].data.slice(read_upto, read_upto + BUFF_SIZE)
	float_buf = buf.unpack("f#{BUFF_SIZE}")
	sample_size = BUFF_SIZE
	if float_buf.index(nil) 
		sample_size = float_buf.index(nil)
	end
#	puts "Sample size = #{sample_size}"
#	(0..4).each { |i|
#		index = Random.rand(1024)
#		puts "float_buf[#{index}] = #{float_buf[index]} (#{float_buf[index].class.name})"
#	}
	bpm_detector.inputSamples(float_buf[0..sample_size-1], sample_size)
	buffer_count += 1
	read_upto += BUFF_SIZE
#	if sample_size != BUFF_SIZE
#		print '*'
#	else
#		print '.'
#	end
	print '.' if buffer_count % 10 == 0
end
puts "\nread #{buffer_count} buffers. Read upto: #{read_upto}. Data size = #{max_read_limit}"
# read the tail data
buf.clear
float_buf.clear
buf = chunks[0].data.slice(read_upto, max_read_limit)
bytes = (max_read_limit - read_upto)/4
puts "Remaining bytes = #{bytes}"
float_buf = buf.unpack("f#{bytes}")
bpm_detector.inputSamples(float_buf, bytes)
#
bpm = bpm_detector.getBpm()
puts "BPM = #{bpm}"

