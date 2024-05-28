from ecgdetectors import Detectors
import scipy.io as sio
import sys
import numpy

print(sys.argv)

mat_fname = sys.argv[1]
print(mat_fname)
mat_contents = sio.loadmat(mat_fname)

ECG = numpy.squeeze(mat_contents.get('ECG'))
detectors = Detectors(int(sys.argv[2]))

r_peaks = []

detector_name = sys.argv[3]
if detector_name == "swt":
    r_peaks = detectors.swt_detector(ECG)
if detector_name == "two_averaged":
    r_peaks = detectors.two_average_detector(ECG)
if detector_name == "wqrs":
    r_peaks = detectors.wqrs_detector(ECG)
if detector_name == "christov":
    r_peaks = detectors.christov_detector(ECG)
if detector_name == "engzee":
    r_peaks = detectors.engzee_detector(ECG)
if detector_name == "hamilton":
    r_peaks = detectors.hamilton_detector(ECG)
if detector_name == "pan_tompkins":
    r_peaks = detectors.pan_tompkins_detector(ECG)

result  = {"R": r_peaks}
sio.savemat(mat_fname, result)
