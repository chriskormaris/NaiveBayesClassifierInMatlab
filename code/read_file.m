function [ file_contents ] = read_file( filepath )
%READ_FILE Summary of this function goes here

    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

    filepath = char(strcat(strcat(pwd, '/'), filepath));

    fid = fopen(filepath, "r");
    if fid,
        if ~isOctave,  % for Matlab
            file_contents = fscanf(fid, '%c', inf);
        else,  % for Octave
            file_contents = textscan(fid, '%s');
            file_contents = file_contents{:};
        end
        fclose(fid);
    else,
        file_contents = '';
        fprintf('Unable to open %s\n', filepath);
    end

end
