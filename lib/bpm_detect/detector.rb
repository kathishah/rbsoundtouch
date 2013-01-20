module BpmDetect
    class Detector
        def initialize(channels, sample_rate)
            @channels = channels
            @sample_rate = sample_rate
            @decimate_sum = 0
            @decimate_count = 0
            @envelope_accu = 0

            # choose decimation factor so that result is approx. 1000 Hz
            @decimate_by = @sample_rate / 1000
            raise "Failed: decimate_by > 0" unless @decimate_by > 0
            raise "Failed: INPUT_BLOCK_SAMPLES < @decimate_by * DECIMATED_BLOCK_SAMPLES" unless INPUT_BLOCK_SAMPLES < @decimate_by * DECIMATED_BLOCK_SAMPLES

            # Calculate window length & starting item according to desired min & max bpms
            @window_len = (60 * @sample_rate) / (@decimate_by * MIN_BPM)
            @window_start = (60 * @sample_rate) / (@decimate_by * MAX_BPM)

            raise "Failed: @window_len > @window_start" unless @window_len > @window_start

            # allocate new working objects
            @xcorr = Array.new(@window_len)

            # allocate processing buffer
            @buffer = Object.new # new FIFOSampleBuffer();
            # we do processing in mono mode
            @buffer.channels = 1
            @buffer.clear
        end

        private
        def decimate(src, sample_count)
            dest = []
            out = 0.0
            raise "Fail: channels > 0" unless @channels > 0
            raise "Fail: decimate_by > 0" unless @decimate_by > 0

            out_count = 0
            0.upto(sample_count-1).each{ |count|
                j = 0
                0.upto(channels-1).each{ |j|
                    @decimate_sum += src[j]
                }
                src += j #TODO - what does this mean

                @decimate_count += 1
                if @decimate_count >= @decimate_by
                    out = @decimate_sum / (@decimate_by * @channels)
                    @decimate_count = 0
                    @decimate_sum   = 0
                    dest[out_count] = out
                    out_count += 1
                end
            }
            return dest
        end

        def update_xcorr(process_samples)
            raise "Fail: buffer.samples >= process_samples + window_len" unless @buffer.num_samples >= process_samples + @window_len
            p_buffer = @buffer.begin_ptr
            @window_start.upto(@window_len-1).each{ |offs|
                sum = 0.0
                0.upto(process_samples-1).each{ |i|
                    sum += @buffer[p_buffer + i] * @buffer[p_buffer + i + offs]
                }
                @xcorr[offs] += sum
            }
        end
    end
end
