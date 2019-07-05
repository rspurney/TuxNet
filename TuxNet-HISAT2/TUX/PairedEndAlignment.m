function [alignmentStatus] = PairedEndAlignment(app, mainFolder, mainFolderNoSpace, threads)
%%
% Calls hisat2 to align cleaned paired-end .fastq files and then converts
% to .bam and sorts

%%
inputFolders = dir(mainFolder); % List of all files and folders in input folder
dirFlags = [inputFolders.isdir]; % Logical vector that tells which is a directory
subFolders = inputFolders(dirFlags); % Extract only directories
subFolders(ismember({subFolders.name}, {'.', '..', 'Cleaned', 'Aligned'})) = []; % Remove directories

%%
for j = 1 : length(subFolders)
    filePattern = fullfile(mainFolder, subFolders(j).name, 'A_*.fastq*');
    gzFiles = dir(filePattern); % Find all A_*.fastq files in provided folder

    for k = 1 : length(gzFiles)
        % hisat2
        app.Tux_StatusField_Tuxedo.Value = "hisat2 " + "Cleaned" + subFolders(j).name + "_" + k + ".fastq...";
        drawnow
        alignmentCommand = "./hisat2/hisat2 --dta-cufflinks -p " + threads + " -x index " +...
            " -1 '" + mainFolderNoSpace + "/Cleaned/A_Cleaned" + subFolders(j).name + "_" + k + ".fastq'" +...
            " -2 '" + mainFolderNoSpace + "/Cleaned/B_Cleaned" + subFolders(j).name + "_" + k + ".fastq'" +...
            " -S " + "hisat2Out" + subFolders(j).name + "_" + k + ".sam";
        alignmentStatus = system(alignmentCommand);
        if(alignmentStatus ~= 0)
            message = 'An error occurred during alignment.';
            uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
            app.Tux_StatusField_Tuxedo.Value = "hisat2 Failed on " +...
                "Cleaned" + subFolders(j).name + "_" + k + ".fastq";
            alignmentStatus = 1;
            return;
        end

        % samtools sam to bam
        app.Tux_StatusField_Tuxedo.Value = "samtools sam to bam " + "hisat2Out" + subFolders(j).name +...
            "_" + k + ".sam...";
        drawnow
        samtoolsCommand = "./samtools/samtools view -bS hisat2Out" + subFolders(j).name + "_" + k + ".sam > hisat2Out" +...
            subFolders(j).name + "_" + k + ".bam";
        samtoolStatus = system(samtoolsCommand);
        if(samtoolStatus ~= 0)
            message = 'An error occurred during sam to bam conversion.';
            uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
            app.Tux_StatusField_Tuxedo.Value = "samtools sam to bam Failed on " +...
                "hisat2Out" + subFolders(j).name + "_" + k + ".sam";
            alignmentStatus = 1;
            return;
        end

        % samtools sort
        app.Tux_StatusField_Tuxedo.Value = "samtools sort bam " + "hisat2Out" + subFolders(j).name +...
             "_" + k + ".bam...";
        drawnow
        samtoolsCommand = "./samtools/samtools sort -T temp -o hisat2OutSorted" +...
            subFolders(j).name + "_" + k + ".bam hisat2Out" + subFolders(j).name + "_" + k + ".bam";
        samtoolStatus = system(samtoolsCommand);
        if(samtoolStatus ~= 0)
            message = 'An error occurred during sorting.';
            uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
            app.Tux_StatusField_Tuxedo.Value = "samtools sort Failed on " +...
                "hisat2Out" + subFolders(j).name + "_" + k + ".bam";
            alignmentStatus = 1;
            return;
        end
    end
end

alignmentStatus = 0;
end

