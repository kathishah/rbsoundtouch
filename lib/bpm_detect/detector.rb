module BpmDetect
	class Detector
		def initialize(channels, sample_rate)
			@channels = channels
			@sample_rate = sample_rate
			@decimate_sum = 0
			@decimate_count = 0
			@envelope_accu = 0

			// choose decimation factor so that result is approx. 1000 Hz
			@decimate_by = @sample_rate / 1000;
			assert(@decimate_by > 0);
			assert(INPUT_BLOCK_SAMPLES < @decimate_by * DECIMATED_BLOCK_SAMPLES);

			// Calculate window length & starting item according to desired min & max bpms
			@window_len = (60 * @sample_rate) / (@decimate_by * MIN_BPM);
			@window_start = (60 * @sample_rate) / (@decimate_by * MAX_BPM);

			assert(@window_len > @window_start);

			// allocate new working objects
			@xcorr = Array.new(@window_len);

			// allocate processing buffer
			@buffer = new FIFOSampleBuffer();
			// we do processing in mono mode
			@buffer.channels = 1
			@buffer.clear
		end
	end
end
