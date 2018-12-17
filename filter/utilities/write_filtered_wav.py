from scipy.io import wavfile
import numpy as np
import matplotlib.pyplot as plt
from scipy.fftpack import fft

if __name__ == "__main__":
   filt_f = open("output_file.txt", "r")
   lines = filt_f.readlines()
   lines = np.array(lines, dtype=np.int16)
   wavfile.write('FrequencyTest_filtered.wav', 11025, lines)
   filt_f.close()
