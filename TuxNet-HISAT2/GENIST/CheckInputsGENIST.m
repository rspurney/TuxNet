function [inputsStatus, clusteringFile, TFFile, symbolFile] = CheckInputsGENIST(app, outputsFolder, genesFile, timecourseFile, clusteringFile, TFFile, symbolFile, filenameResults)
%%
% Checks input files for GENIST

%%
inputsStatus = 1;

if(strcmp(outputsFolder, '')) % Check if required filename has been provided
    message = 'Please provide an outputs folder.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.GENIST_StatusField.Value = "Error";
    return;
end

if(strcmp(genesFile, '')) % Check if required filename has been provided
    message = 'Please provide a genes file.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.GENIST_StatusField.Value = "Error";
    return;
end

if(strcmp(timecourseFile, '')) % Check if required filename has been provided
    message = 'Please provide a timecourse file.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.GENIST_StatusField.Value = "Error";
    return;
end

if(exist(outputsFolder, 'dir') == 0) % Check if given file exists
    message = 'Provided outputs folder cannot be found.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.GENIST_StatusField.Value = "Error";
    return;
end

if(exist(genesFile, 'file') == 0) % Check if given file exists
    message = 'Provided genes file cannot be found.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.GENIST_StatusField.Value = "Error";
    return;
end

if(exist(timecourseFile, 'file') == 0) % Check if given file exists
    message = 'Provided timecourse file cannot be found.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.GENIST_StatusField.Value = "Error";
    return;
end

if(strcmp(filenameResults, '')) % Check if output filename has been provided
    message = 'Please provide an output file name.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.GENIST_StatusField.Value = "Error";
    return;
end

if(strcmp(clusteringFile, '')) % Check if optional file is given
    clusteringFile = [];
else
    if(exist(clusteringFile, 'file') == 0) % Check if optional file exists
        message = 'Provided clustering file cannot be found.';
        uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
        app.GENIST_StatusField.Value = "Error";
        return;
    end
end

if(strcmp(TFFile, '')) % Check if optional file is given
    TFFile = [];
else
    if(exist(TFFile, 'file') == 0) % Check if optional file exists
        message = 'Provided TF file cannot be found.';
        uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
        app.GENIST_StatusField.Value = "Error";
        return;
    end
end

if(strcmp(symbolFile, '')) % Check if optional file is given
    symbolFile = [];
else
    if(exist(symbolFile, 'file') == 0) % Check if optional file exists
        message = 'Provided gene name file cannot be found.';
        uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
        app.GENIST_StatusField.Value = "Error";
        return;
    end
end

inputsStatus = 0;
end

