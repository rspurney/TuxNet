function [inputsStatus, expressionFlag, clusteringFlag, expressionFile, symbolFile, clusteringFile, timecourseFile] = CheckInputsRTPSTAR(app, outputsFolder, genesFile, expressionFile, symbolFile, TFFile, clusteringFile, timecourseFile, filenameResults)
%%
% Check inputs for RTP-STAR

%%
inputsStatus = 1;
expressionFlag = 0;
clusteringFlag = 0;

if(strcmp(outputsFolder, ''))
    message = 'Please provide an outputs folder.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.RTP_StatusField.Value = "Error";
    return;
end

if(strcmp(genesFile, ''))
    message = 'Please provide a genes file.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.RTP_StatusField.Value = "Error";
    return;
end

if(strcmp(expressionFile, ''))
    message = 'Please provide a gene expression file.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.RTP_StatusField.Value = "Error";
    return;
end

if(exist(outputsFolder, 'dir') == 0)
    message = 'Provided outputs folder cannot be found.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.RTP_StatusField.Value = "Error";
    return;
end

if(exist(genesFile, 'file') == 0)
    message = 'Provided genes file cannot be found.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.RTP_StatusField.Value = "Error";
    return;
end

if(exist(expressionFile, 'file') == 0)
    message = 'Provided gene expression file cannot be found.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.RTP_StatusField.Value = "Error";
    return;
end

if(strcmp(filenameResults, ''))
    message = 'Please provide a results file name.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.RTP_StatusField.Value = "Error";
    return;
end

if(strcmp(symbolFile, ''))
    symbolFile = [];
else
    if(exist(symbolFile, 'file') == 0)
        message = 'Provided gene name file cannot be found.';
        uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
        app.RTP_StatusField.Value = "Error";
        return;
    end
end

expression = readtable(expressionFile);
if(strcmp(TFFile, ''))
    % Check if TF column already exists
    columnsComp = strcmp('TF', expression.Properties.VariableNames);
    columnsFlag = any(columnsComp);
    % If there is no TF file and no TF column, add in a row of 0s
    if(columnsFlag == 0)
        expression.TF = ones(size(expression, 1), 1);
        expression = [expression(:, 1) expression(:, size(expression, 2)) expression(:, 2:size(expression, 2) - 1)];
        writetable(expression, 'expressionWithTFs.xlsx');
        expressionFile = 'expressionWithTFs.xlsx';
        expressionFlag = 1;
    end
else
    if(exist(TFFile, 'file') == 0)
        message = 'Provided TF file cannot be found.';
        uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
        app.RTP_StatusField.Value = "Error";
        return;
    end
    columnsComp = strcmp('TF', expression.Properties.VariableNames);
    columnsFlag = any(columnsComp);
    % Integrate TFs into expression file if there is no TF column
    if(columnsFlag == 0)
        TFs = readtable(TFFile);
        expression.TF = ismember(expression{:, 1}, TFs{:, 1});
        expression = [expression(:, 1) expression(:, size(expression, 2)) expression(:, 2:size(expression, 2) - 1)];
        writetable(expression, 'expressionWithTFs.xlsx');
        expressionFile = 'expressionWithTFs.xlsx';
        expressionFlag = 1;
    end
end

if(strcmp(clusteringFile, ''))
    clusteringFile = [];
else
    if(exist(clusteringFile, 'file') == 0)
        message = 'Provided clustering file cannot be found.';
        uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
        app.RTP_StatusField.Value = "Error";
        return;
    end
    clusteringFlag = 1;
end

if(strcmp(timecourseFile, ''))
    timecourseFile = [];
else
    if(exist(timecourseFile, 'file') == 0)
        message = 'Provided time course file cannot be found.';
        uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
        app.RTP_StatusField.Value = "Error";
        return;
    end
end

inputsStatus = 0;
end