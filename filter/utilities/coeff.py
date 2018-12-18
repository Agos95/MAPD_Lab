from scipy import signal
from scipy.signal import freqz
import numpy as np
import matplotlib.pyplot as plt

if __name__ == "__main__": 

   fs = 11025 # Hz -- Frequency used in the wav audio files.
#  b = signal.firwin(numtaps=5, cutoff=0.1, window='boxcar') # lowpass
#  b = signal.firwin(numtaps=5, cutoff=0.9, pass_zero=False, window='boxcar') # highpass
#  b = signal.firwin(numtaps=5, cutoff=[0.1, 0.9], window='boxcar') # bandstop
   b = signal.firwin(numtaps=5, cutoff=[0.4, 0.6], pass_zero=False, window='boxcar') # bandpass
   w, h = signal.freqz(b)
   print ("coefficients : ")
   print (b)

   fig = plt.figure()
   fig.set_size_inches(16, 12, forward=True)
   ax1 = fig.add_subplot(211)   
   ax1.plot(w/3.14, 20*np.log10(abs(h))) 
   ax1.set_xlabel('w [Frequency [rad/samples]')
   ax1.set_ylabel('Amplitude [dB]')
   ax1.set_title('Digital Frequency Filter Response')
   ax1.grid()
   ax2 = fig.add_subplot(212)
   ax2.plot(w/3.14*fs/2, 20*np.log10(abs(h))) 
   ax2.set_xlim(min(w/3.14*fs/2), max(w/3.14*fs/2))
   ax2.set_xlabel('f [Frequency [Hz]')
   ax2.set_ylabel('Amplitude [dB]')
   ax2.grid()
   fig.savefig('f_response.png')

