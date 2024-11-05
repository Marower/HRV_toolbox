function [Signal, error] = LMS_filtration (ECG, Noise, Order)
    filename = './temp.mat';
    save(filename,'ECG','Noise')
    %Provide valid path to detectQRS.py script
    if isfile('detectQRS.py')
        % Script exists.
        syscmd = sprintf ('python ./NLMS.py %s %d', filename, Order);
    else
        % Script does not exist.
        %Provide correct path
        syscmd = sprintf ('python D:/Matlab_workspace/HRV_toolbox/Functions/NLMS.py %s %d', filename, Order);
    end
   
    system(syscmd)
    try
        Result = load(filename, 'S', 'E');

        Signal = Result.S;
        error = Result.E;
    catch
        disp 'Something went wrong during R peaks detections, check if NLMS script is in a folder poth'
        Signal = [];
        error = [];
    end
    delete(filename)
end