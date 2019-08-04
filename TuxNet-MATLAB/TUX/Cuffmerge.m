function [cuffmergeStatus] = Cuffmerge(app, mainFolder, threads, GTFFile, FASTAFile)
%%
% Calls Cuffmerge on Cufflinks assemblies

%%
app.Tux_StatusField_Tuxedo.Value = "Cuffmerge...";
drawnow
cuffmergeCommand = "./cufflinks/cuffmerge -g " + GTFFile +...
    " -s " + FASTAFile + " -p " + threads + " " + "'" +...
    mainFolder + "/Cufflinks/assemblies.txt';";
cuffmergeStatus = system(cuffmergeCommand);
if(cuffmergeStatus ~= 0)
    message = 'An error occurred during Cuffmerge.';
    uialert(app.UIFigure, message, 'Error', 'Icon', 'error');
    app.Tux_StatusField_Tuxedo.Value = "Cuffmerge Failed";
    cuffmergeStatus = 1;
    return
end

cuffmergeStatus = 0;
end

