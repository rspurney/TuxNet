%Write biograph results to .txt file for cytoscape
%
%Parameters: 
%bg2 is a biograph produced by regression tree algorithm
%
%istimecourse:boolean variable (true/false) that indicates if a timecourse
%was used for directionality. Default is true.
%
%filename is the name of the file where you want to write results. 
%Default name is biograph.txt
%
%Author:
%Natalie M. Clark
%Biomathematics Graduate Program
%North Carolina State University
%Email: nmclark2@ncsu.edu
%Last updated: November 3, 2016

function biograph_to_text(bg2,istimecourse,filename)

%check if parameters exist
%if not, set defaults
if ~exist('istimecourse', 'var') || isempty(istimecourse)
    istimecourse = true; 
end
if ~exist('filename', 'var') || isempty(filename)
    filename = 'biograph.txt';
end

edges = get(bg2.edges,'ID');
%get colors of edges (activation or repression)
colors = get(bg2.edges,'LineColor');
%get number of edges
numberedges=size(edges,1);

%open file
fileID = fopen(filename,'a');

%for each edge, check color
%if green, activates
%if red, represses
%if neither, directionality unknown
if istimecourse
    if numberedges == 1
        nodes = strsplit(edges, ' -> ');
        if colors == [1.0 0 0]
            fprintf(fileID,'%s %s %s\n',nodes{1},'inhibits',nodes{2});
        elseif colors == [0 1.0 0]
            fprintf(fileID,'%s %s %s\n',nodes{1},'activates',nodes{2});
        else
            fprintf(fileID,'%s %s %s\n',nodes{1},'regulates',nodes{2});
        end
    else
        for i = 1:numberedges
            edge = edges(i);
            nodes = strsplit(edge{1}, ' -> ');
            if colors{i} == [1.0 0 0]
                fprintf(fileID,'%s %s %s\n',nodes{1},'inhibits',nodes{2});
            elseif colors{i} == [0 1.0 0]
                fprintf(fileID,'%s %s %s\n',nodes{1},'activates',nodes{2});
            else
                fprintf(fileID,'%s %s %s\n',nodes{1},'regulates',nodes{2});
            end
        end
    end
%if we didn't use timecourse, all edges are grey
%so just print without directionality
else
    if numberedges == 1
        nodes = strsplit(edges, ' -> ');
        fprintf(fileID,'%s %s %s\n',nodes{1},'regulates',nodes{2});
    else
        for i = 1:numberedges
            edge = edges(i);
            nodes = strsplit(edge{1}, ' -> ');
            fprintf(fileID,'%s %s %s\n',nodes{1},'regulates',nodes{2});
        end
    end
end

fclose(fileID);

end