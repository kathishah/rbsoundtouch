module BpmDetect
	INPUT_BLOCK_SAMPLES     = 2048
	DECIMATED_BLOCK_SAMPLES = 256
	AVG_DECAY 				      = 0.99986
	AVG_NORM 				        = (1 - AVG_DECAY)
	RMS_VOLUME_ACCU         = (0.045 * 0.045) / AVG_NORM; #for float samples
  MIN_BPM                 = 29
  MAX_BPM                 = 200
end
