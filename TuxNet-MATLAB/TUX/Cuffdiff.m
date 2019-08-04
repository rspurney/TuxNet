function [cuffdiffStatus] = Cuffdiff(app, mainFolder, threads, FASTAFile, readType)
%%
% Calls Cuffdiff on Cufflinks assemblies

%%
inputFolders = dir(mainFolder); % List of all files and folders in input folder
dirFlags = [inputFolders.isdir]; % Logical vector that tells which is a directory
subFolders = inputFolders(dirFlags); % Extract only directories
subFolders(ismember({subFolders.name}, {'.', '..', 'Cleaned', 'Aligned'})) = []; % Remove directories

%%
app.Tux_StatusField_Tuxedo.Value = "Cuffdiff...";
drawnow
% Generate Gene Labels parameter
geneLabels = "";
for j = 1 : length(subFolders)
    if(readType == '0') % Single-End
        filePattern = fullfile(mainFolder, subFolders(j).name, '*.fastq*');
    elseif(readType == '1') % Paired-End
        filePattern = fullfile(mainFolder, subFolders(j).name, 'A_*.fastq*');
    end
    gzFiles = dir(filePattern); % Find all .fastq files in provided folder
    if(~isempty(gzFiles)) % If folder contains .fastq files, add to Gene Labels list
        geneLabels = geneLabels + subFolders(j).name + ",";
    end
end
geneLabels = regexprep(geneLabels, '.$', '', 'lineanchors'); % Remove extra ','

% Build Cuffdiff command and run
cuffdiffCommand = "./cufflinks/cuffdiff -q -o diff_out -b " + FASTAFile +...
    " -p " + threads + " -L " + geneLabels + " -u '" + mainFolder +...
    "/merged_asm/merged.gtf' \" + newline;
for j = 1 : length(subFolders)
    if(readType == '0') % Single-End
        filePattern = fullfile(mainFolder, subFolders(j).name, '*.fastq*');
    elseif(readType == '1') % Paired-End
        filePattern = fullfile(mainFolder, subFolders(j).name, 'A_*.fastq*');
    end
    gzFiles = dir(filePattern); % Find all .fastq files in provided folder
    for k = 1 : length(gzFiles) % Generate groupings
        if(k == length(gzFiles))
            cuffdiffCommand = cuffdiffCommand + "'" + mainFolder +...
                "/Aligned/hisat2OutSorted" + subFolders(j).name + "_" +...
                k + ".sam' \" + "" + newline;
        else
            cuffdiffCommand = cuffdiffCommand + "'" + mainFolder +...
                "/Aligned/hisat2OutSorted" + subFolders(j).name + "_" +...
                k + ".sam'" + ",";
        end
    end
end
cuffdiffStatus = system(cuffdiffCommand);
if(cuffdiffStatus ~= 0)
    app.Tux_StatusField_Tuxedo.Value = "Cuffdiff Failed";
    message = 'An error occurred during Cuffdiff.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.Tux_StatusField_Tuxedo.Value = "Cuffdiff Failed";
    cuffdiffStatus = 1;
    return
end

cuffdiffStatus = 0;
end

