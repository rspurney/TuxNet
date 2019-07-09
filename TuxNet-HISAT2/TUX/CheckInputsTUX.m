function [inputsStatus] = CheckInputsTUX(app, mainFolder, GTFFile, FASTAFile)
%%
% Check inputs for TUX

%%
inputsStatus = 1;

if(strcmp(mainFolder, ''))
    message = 'Please provide an inputs folder name.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.Tux_StatusField_Tuxedo.Value = "Error";
    return;
end

if(strcmp(GTFFile, ''))
    message = 'Please provide a reference genome file name.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.Tux_StatusField_Tuxedo.Value = "Error";
    return;
end

if(strcmp(FASTAFile, ''))
    message = 'Please provide a FASTA file name.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.Tux_StatusField_Tuxedo.Value = "Error";
    return;
end

if(exist(mainFolder, 'dir') == 0)
    message = 'Provided inputs folder cannot be found.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.Tux_StatusField_Tuxedo.Value = "Error";
    return;
end

if(exist(GTFFile, 'file') == 0)
    message = 'Provided reference genome file cannot be found.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.Tux_StatusField_Tuxedo.Value = "Error";
    return;
end

if(exist(FASTAFile, 'file') == 0)
    message = 'Provided FASTA file cannot be found.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.Tux_StatusField_Tuxedo.Value = "Error";
    return;
end

% Check for already existing output folders
checkFolders = [mainFolder + "/Cleaned", mainFolder + "/Aligned",...
    mainFolder + "/Cufflinks", mainFolder + "/merged_asm",...
    mainFolder + "/diff_out"];
if(any(isfolder(checkFolders)))
    message = ['One or more output folders already exists in your inputs '...
        'folder: Cleaned, Aligned, Cufflinks, merged_asm, diff_out. Delete '...
        'these folders or choose a different inputs folder.'];
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.Tux_StatusField_Tuxedo.Value = "Error";
    return;
end

inputsStatus = 0;
end

