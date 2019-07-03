function [cleaningStatus] = SingleEndCleaning(app, mainFolder, qualityThresh, minSeqLength, windowSize)
%%
% Calls ea-utils fastq-mcf to clean raw single-end .fastq files

%%
inputFolders = dir(mainFolder); % List of all files and folders in input folder
dirFlags = [inputFolders.isdir]; % Logical vector that tells which is a directory
subFolders = inputFolders(dirFlags); % Extract only directories
subFolders(ismember({subFolders.name}, {'.', '..', 'Cleaned', 'Aligned'})) = []; % Remove directories
if(length(subFolders) < 1)
    message = 'No subfolders found in Inputs Folder.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.Tux_StatusField_Tuxedo.Value = "Error";
    cleaningStatus = 1;
    return;
end

%%
for j = 1 : length(subFolders)
    filePattern = fullfile(mainFolder, subFolders(j).name, '*.fastq*');
    gzFiles = dir(filePattern); % Find all .fastq files in provided folder
    if(length(gzFiles) < 1)
        message = 'No .fastq files found in Inputs Folder.';
        uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
        app.Tux_StatusField_Tuxedo.Value = "Error";
        cleaningStatus = 1;
        return;
    end

    for k = 1 : length(gzFiles) % Run cleaning algorithm on each found .gz file
        baseFileName = gzFiles(k).name;
        fullFileName = fullfile(mainFolder, subFolders(j).name, baseFileName);
        app.Tux_StatusField_Tuxedo.Value = "Cleaning " + baseFileName + "...";
        drawnow
        cleaningCommand = "./ea-utils/fastq-mcf IlluminaAdaptorSeq.fasta " +...
            "'" + fullFileName + "'" + " -q " + qualityThresh +...
            " -l " + minSeqLength + " -w " + windowSize +...
            " -o " + "Cleaned" + subFolders(j).name + "_" + k + ".fastq;";
        cleaningStatus = system(cleaningCommand);
        if(cleaningStatus ~= 0) % If command failed to execute
            app.Tux_StatusField_Tuxedo.Value = "Cleaning Failed on " + baseFileName;
            message = 'An error occurred during Cleaning.';
            uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
            app.Tux_StatusField_Tuxedo.Value = "Error";
            cleaningStatus = 1;
            return;
        end
    end
end

cleaningStatus = 0;
end

