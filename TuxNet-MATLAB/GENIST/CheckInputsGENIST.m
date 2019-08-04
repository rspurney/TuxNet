function [inputsStatus, clusteringFile, TFFile, symbolFile] = CheckInputsGENIST(app, outputsFolder, genesFile, timecourseFile, clusteringFile, TFFile, symbolFile, filenameResults)
%%
% Checks input files for GENIST

%%
inputsStatus = 1;

if(strcmp(outputsFolder, ''))
    message = 'Please provide an outputs folder.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.GENIST_StatusField.Value = "Error";
    return;
end

if(strcmp(genesFile, ''))
    message = 'Please provide a genes file.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.GENIST_StatusField.Value = "Error";
    return;
end

if(strcmp(timecourseFile, ''))
    message = 'Please provide a timecourse file.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.GENIST_StatusField.Value = "Error";
    return;
end

if(exist(outputsFolder, 'dir') == 0)
    message = 'Provided outputs folder cannot be found.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.GENIST_StatusField.Value = "Error";
    return;
end

if(exist(genesFile, 'file') == 0)
    message = 'Provided genes file cannot be found.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.GENIST_StatusField.Value = "Error";
    return;
end

if(exist(timecourseFile, 'file') == 0)
    message = 'Provided timecourse file cannot be found.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.GENIST_StatusField.Value = "Error";
    return;
end

if(strcmp(filenameResults, ''))
    message = 'Please provide an output file name.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.GENIST_StatusField.Value = "Error";
    return;
end

if(strcmp(clusteringFile, ''))
    clusteringFile = [];
else
    if(exist(clusteringFile, 'file') == 0)
        message = 'Provided clustering file cannot be found.';
        uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
        app.GENIST_StatusField.Value = "Error";
        return;
    end
end

if(strcmp(TFFile, ''))
    TFFile = [];
else
    if(exist(TFFile, 'file') == 0)
        message = 'Provided TF file cannot be found.';
        uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
        app.GENIST_StatusField.Value = "Error";
        return;
    end
end

if(strcmp(symbolFile, ''))
    symbolFile = [];
else
    if(exist(symbolFile, 'file') == 0)
        message = 'Provided gene name file cannot be found.';
        uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
        app.GENIST_StatusField.Value = "Error";
        return;
    end
end

inputsStatus = 0;
end

