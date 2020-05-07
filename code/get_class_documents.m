function [ class_documents ] = get_class_documents( files_dir, filenames )
%GET_CLASSIFICATION_DATA Summary of this function goes here

    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

    N = length(filenames);
    class_documents = strings(N, 1);
    % stop_words = stopWords('Language', 'en');

    % reading files
    for i = 1:N
        if ~isOctave
            fprintf("Reading %s file \'%s\'...\n", 'train', filenames{i});
        else
            fprintf("Reading %s file \'%s\'...\n", 'train', strrep(filenames(i, :), ' ', ''));  % call "strrep" to remove whitespaces
            fflush(stdout);
        end
        
        if ~isOctave
            text = read_file(strcat(files_dir, filenames(i)));        
        else
            text = read_file(strcat(files_dir, strrep(filenames(i, :), ' ', '')));  % call "strrep" to remove whitespaces
        end

        % text = removeStopWords(text);

        class_documents(i) = text;
    end
    
    fprintf('\n');
    
end
