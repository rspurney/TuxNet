function [cleaningStatus] = PairedEndCleaning(app, mainFolder, qualityThresh, minSeqLength, windowSize)
%%
% Calls ea-utils fastq-mcf to clean raw paired-end .fastq files

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
    filePattern = fullfile(mainFolder, subFolders(j).name, 'A_*.fastq*');
    gzFiles = dir(filePattern); % Find all A_*.fastq files in provided folder
    if(length(gzFiles) < 1)
        message = char("No .fastq files found in " + subFolders(j).name + ".");
        uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
        app.Tux_StatusField_Tuxedo.Value = "Error";
        cleaningStatus = 1;
        return;
    end

    for k = 1 : length(gzFiles) % Run cleaning algorithm on each found .gz file pair
        baseFileName = gzFiles(k).name;
        reducedFileName = baseFileName(3 : end); % Remove A_
        fullFileName_A = fullfile(mainFolder, subFolders(j).name, baseFileName);
        fullFileName_B = fullfile(mainFolder, subFolders(j).name, "B_" + reducedFileName);
        
        app.Tux_StatusField_Tuxedo.Value = "Cleaning " + reducedFileName + "...";
        drawnow
        cleaningCommand = "./ea-utils/fastq-mcf IlluminaAdaptorSeq.fasta " +...
            "'" + fullFileName_A + "'" + " '" + fullFileName_B + "'" +...
            " -q " + qualityThresh + " -l " + minSeqLength + " -w " + windowSize +...
            " -o " + "A_Cleaned" + subFolders(j).name + "_" + k + ".fastq" +...
            " -o " + "B_Cleaned" + subFolders(j).name + "_" + k + ".fastq;";
        cleaningStatus = system(cleaningCommand);
        if(cleaningStatus ~= 0)
            message = 'An error occurred during Cleaning.';
            uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
            app.Tux_StatusField_Tuxedo.Value = "Cleaning Failed on " +...
                baseFileName;
            cleaningStatus = 1;
            return;
        end
    end
end

cleaningStatus = 0;
end

