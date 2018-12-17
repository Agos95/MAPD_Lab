from scipy.io import wavfile
import numpy as np
import matplotlib.pyplot as plt
from scipy.fftpack import fft

if __name__ == "__main__":
   fs, data = wavfile.read('FrequencyTest.wav')
   times = np.arange(len(data))/float(fs)
   d = data
   t = times


   fs1, data1 = wavfile.read('FrequencyTest_filtered.wav')
   times1 = np.arange(len(data1))/float(fs1)
   d1 = data1
   t1 = times1


   fig = plt.figure()
   ax1 = fig.add_subplot(211)
   ax1.plot(t,d)
   ax1.set_xlabel('Time [s]')
   ax1.set_ylabel('Original')
   ax1.set_xlim(min(t), max(t), 'g')
   ax2 = fig.add_subplot(212)
   ax2.plot(t1,d1,'r')
   ax2.set_xlabel('Time [s]')
   ax2.set_ylabel('Filtered')
   ax2.set_xlim(min(t1), max(t1))
   fig.savefig('t_plot.png')

   

