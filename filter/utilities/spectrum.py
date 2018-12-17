from scipy.io import wavfile
import numpy as np
import matplotlib.pyplot as plt
from scipy.fftpack import fft

if __name__ == "__main__":
   
   fs, data = wavfile.read('FrequencyTest.wav')
   times = np.arange(len(data))/float(fs)

   fs1, data1 = wavfile.read('FrequencyTest_filtered.wav')
   times1 = np.arange(len(data1))/float(fs1)

   print "sampling frequencies : ", fs, fs1

   sig_orig=[(l/2**16.)*2-1 for l in data] 
   fft_orig = fft(sig_orig) 
   f1 = np.arange(len(data)); f2 = len(data)/fs; freq_orig = f1/f2;
   plt.semilogx(freq_orig[0:(len(fft_orig)/2 -1)],20*np.log10(abs(fft_orig[0:(len(fft_orig)/2 -1)])),'b') 


   sig_filt=[(l/2**16.)*2-1 for l in data1] 
   fft_filt = fft(sig_filt) 
   f1 = np.arange(len(data)); f2 = len(data)/fs; freq_filt = f1/f2;


   fig = plt.figure()
   ax1 = fig.add_subplot(211)   
   ax1.semilogx(freq_orig[0:(len(fft_orig)/2 -1)],20*np.log10(abs(fft_orig[0:(len(fft_orig)/2 -1)])),'b') 
   ax1.set_xlabel('F [Hz]')
   ax1.set_ylabel('Original')
   ax1.grid()
   ax1.set_xlim(50, round(fs/2))
   ax1.set_ylim(-60, 80)
   ax2 = fig.add_subplot(212)
   ax2.semilogx(freq_filt[0:(len(fft_filt)/2 -1)],20*np.log10(abs(fft_filt[0:(len(fft_filt)/2 -1)])),'r')
   ax2.set_xlabel('F [Hz]')
   ax2.set_ylabel('Filtered')
   ax2.set_ylim(-60, 80)
   ax2.grid()
   ax2.set_xlim(50, round(fs/2))
   fig.savefig('f_spectrum.png')
