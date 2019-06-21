function [ filenames ] = read_filenames( path )
%READ_LABELS Summary of this function goes here

    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    
    path = strcat(path, '*.txt');

    dirData = dir(path);
        
    if ~isOctave
        filenames = {dirData.name};
    else
        filenames = dirData.name;
    end
    
    % ALTERNATIVE
    filenames = [];
    for i = 1:length(dirData),
        if ~isOctave
            filenames = [filenames; {dirData(i).name}];
        else
            warning("off", "Octave:num-to-str");  % disable warning
            str = dirData(i).name;
            filenames = [filenames; str];  % throws WARNING: implicit conversion from numeric to char
        end
    end

end
