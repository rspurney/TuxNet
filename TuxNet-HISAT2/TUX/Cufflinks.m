function [cufflinksStatus] = Cufflinks(app, mainFolder, threads, GTFFile, FASTAFile, readType)
%%
% Calls Cufflinks on sorted hisat2 output

%%
inputFolders = dir(mainFolder); % List of all files and folders in input folder
dirFlags = [inputFolders.isdir]; % Logical vector that tells which is a directory
subFolders = inputFolders(dirFlags); % Extract only directories
subFolders(ismember({subFolders.name}, {'.', '..', 'Cleaned', 'Aligned'})) = []; % Remove directories

%%
for j = 1 : length(subFolders)
    if(readType == '0') % Single-End
        filePattern = fullfile(mainFolder, subFolders(j).name, '*.fastq*');
    elseif(readType == '1') % Paired-End
        filePattern = fullfile(mainFolder, subFolders(j).name, 'A_*.fastq*');
    end
    gzFiles = dir(filePattern); % Find all .fastq files in provided folder

    for k = 1 : length(gzFiles)
        app.Tux_StatusField_Tuxedo.Value = "Cufflinks " +...
            "hisat2OutSorted" + subFolders(j).name + "_" + k + "...";
        drawnow
        cufflinksCommand = "./cufflinks/cufflinks -p " + threads +...
            " -G " + GTFFile + " -b " + FASTAFile + " -o " +...
            "CufflinksOut" + subFolders(j).name + "_" + k + " "...
            + "'" + mainFolder + "/Aligned/hisat2OutSorted" +...
            subFolders(j).name + "_" + k + ".bam';";
        cufflinksStatus = system(cufflinksCommand);
        if(cufflinksStatus ~= 0) % If command failed to execute
            app.Tux_StatusField_Tuxedo.Value = "Cufflinks Failed on " +...
                "hisat2OutSorted" + subFolders(j).name + "_" + k;
            message = 'An error occurred during Cufflinks.';
            uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
            app.Tux_StatusField_Tuxedo.Value = "Error";
            cufflinksStatus = 1;
            return
        end

        if((j == 1) && (k == 1)) % Generate assemblies.txt file
            fid = fopen('assemblies.txt', 'w');
            fprintf(fid, mainFolder + "/Cufflinks/CufflinksOut" + subFolders(j).name + "_%d/transcripts.gtf\n", k);
            fclose(fid);
        else % Append assemblies.txt file
            fid = fopen('assemblies.txt', 'a');
            fprintf(fid, mainFolder + "/Cufflinks/CufflinksOut" + subFolders(j).name + "_%d/transcripts.gtf\n", k);
            fclose(fid);
        end
    end
end

cufflinksStatus = 0;
end

