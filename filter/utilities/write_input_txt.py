from scipy.io import wavfile
import numpy as np
import matplotlib.pyplot as plt
from scipy.fftpack import fft

if __name__ == "__main__":
   fs, data = wavfile.read('FrequencyTest.wav')
   times = np.arange(len(data))/float(fs)
   d = data
   size = len(d)
   print fs

   orig_f = open("input_file.txt", 'w')
   orig_f.writelines([str(line) + "\n" for line in d])
   orig_f.close()
