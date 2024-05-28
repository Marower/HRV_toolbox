function R = detectRPeaks (ECG, FS, detector)
    filename = './temp.mat';
    save(filename,'ECG')
    %Provide valid path to detectQRS.py script
    if isfile('detectQRS.py')
        % Script exists.
        syscmd = sprintf ('python ./detectQRS.py %s %d %s', filename, FS, detector);
    else
        % Script does not exist.
        %Provide correct path
        syscmd = sprintf ('python D:/Matlab_workspace/HRV_toolbox/Functions/detectQRS.py %s %d %s', filename, FS, detector);
    end
   
    system(syscmd)
    try
        R = load(filename, 'R').R;
    catch
        disp 'Something went wrong during R peaks detections, check if detectQRS script is in a folder'
        R = [];
    end
    delete(filename)
end