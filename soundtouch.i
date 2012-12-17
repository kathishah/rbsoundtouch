/* File : soundtouch.i */
%module soundtouch

%{
#include "/usr/include/soundtouch/soundtouch_config.h"
#include "/usr/include/soundtouch/STTypes.h"
#include "/usr/include/soundtouch/FIFOSamplePipe.h"
#include "/usr/include/soundtouch/FIFOSampleBuffer.h"
#include "/usr/include/soundtouch/BPMDetect.h"
#include "/usr/include/soundtouch/SoundTouch.h"
%}

%include "/usr/include/soundtouch/soundtouch_config.h"
%include "/usr/include/soundtouch/STTypes.h"
%include "/usr/include/soundtouch/FIFOSamplePipe.h"
%include "/usr/include/soundtouch/FIFOSampleBuffer.h"
%include "/usr/include/soundtouch/BPMDetect.h"
%include "/usr/include/soundtouch/SoundTouch.h"
