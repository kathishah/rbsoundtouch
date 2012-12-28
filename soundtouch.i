/* File : soundtouch.i */
%module soundtouch

%typemap(in) soundtouch::SAMPLETYPE const * {
    int size = RARRAY_LEN($input);
    int i;
    $1 = (soundtouch::SAMPLETYPE *) malloc((size+1)*sizeof(soundtouch::SAMPLETYPE));
    /* Get the first element in memory */
    VALUE *ptr = RARRAY_PTR($input);
    for (i=0; i < size; i++, ptr++) {
        /* Convert Ruby Object Array to float* */
        $1[i]= NUM2DBL(*ptr); 
    }
    $1[i]=NULL; /* End of list */
}

// This cleans up the SAMPLETYPE * array created before 
// the function call

%typemap(freearg) soundtouch::SAMPLETYPE const * {
    free((soundtouch::SAMPLETYPE *) $1);
}

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
