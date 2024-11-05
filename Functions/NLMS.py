# pip install padasip
import sys
import padasip as pa
import scipy.io as sio
import numpy as np
if len(sys.argv)>1:
    mat_fname = sys.argv[1]
    print(mat_fname)
    af_order = int(sys.argv[2])
else:
    mat_fname = 'temp.mat'
    af_order = 500
    
mat_contents = sio.loadmat(mat_fname)

ECG = np.squeeze(mat_contents.get('ECG'))
Noise = np.squeeze(mat_contents.get('Noise'))

s = pa.standardize(ECG)
n = pa.standardize(Noise)

x_con = pa.input_from_history(n, af_order)


des = s[af_order-1:len(s)]

f_2 = pa.filters.FilterNLMS(n=af_order, mu=0.01, w="random")

s_acc, e_x, w = f_2.run(des, x_con)

result  = {"E": e_x, "S": s_acc}
sio.savemat(mat_fname, result) 