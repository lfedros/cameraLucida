% PLOT_TREE   Plots a tree.
% (trees package)
%
% HP = plot_tree_lines (intree, color, DD, ipart, options)
% -------------------------------------------------------
%
% Plots a directed graph contained in intree with lines. 
%
% Input
% -----
% - intree   ::integer:      index of tree in trees or structured tree
% - color    ::RGB 3-tupel:  RGB values
%     if vector then values are treated in colormap (must contain one value
%     per node then!).
%     if matrix (N x 3) then individual colors are mapped to each
%     element, works only on line-plots
%     {DEFAULT [0 0 0]}
% - DD       :: 1x3 vector:  coordinates offset
%     {DEFAULT no offset [0,0,0]}
% - ipart    ::index:        index to the subpart to be plotted
%     {DEFAULT: all nodes}
% - options  ::string: has to be one of the following:
%    
%     '-2l'  : 2D (using only X and Y). forces line output (2D), no diameter
%             (slower), color is mapped independently of matlab, always
%             min to max.
%     '-3l'  : 3D. forces line output (2D), no diameter (slower, as '-2l')
% 
%     {DEFAULT '-2l'}
%
% - crange    ::1x2 vector:        limits of colormap range
%
% - cmap    ::string:       name of colormap to use
%    
% Output
% ------
% - HP       ::handles:      links to the graphical objects.
%
% Example
% -------
% plot_tree    (sample_tree)
%
%
% directly adapted for TREES toolbox: edit, generate, visualise and analyse neuronal trees
% Copyright (C) 2009 - 2017  Hermann Cuntz

%LF Rossi 2020

function HP  = plot_tree_lines_LFR(intree, color, DD, ipart, options, crange, cmap, lw)

% trees : contains the tree structures in the trees package
global       trees

if (nargin < 1) || isempty (intree)
    % {DEFAULT tree: last tree in trees cell array}
    intree   = length (trees);
end

ver_tree     (intree); % verify that input is a tree structure

% use full tree for this function
if ~isstruct (intree)
    tree     = trees{intree};
else
    tree     = intree;
end

if (~isfield (tree, 'X')) || (~isfield (tree, 'Y'))
    % if metrics are missing replace by equivalent tree:
    [~, tree] = xdend_tree (intree);
end

N            = size (tree.X, 1); % number of nodes in tree

if (nargin < 4) || isempty (ipart)
    % {DEFAULT index: select all nodes/points}
    ipart    = (1 : N)';
end

if (nargin < 2) || isempty (color)
    % {DEFAULT color: black}
    color    = [0 0 0];
end

if (size (color, 1) == N) && (size (ipart, 1) ~= N)
    color    = color  (ipart);
end
color        = double (color);

if (nargin < 3) || isempty (DD)
    % {DEFAULT 3-tupel: no spatial displacement from the root}
    DD       = [0 0 0];
end
if length (DD) < 3
    % append 3-tupel with zeros:
    DD       = [DD (zeros (1, 3 - length (DD)))];
end

if (nargin < 5) || isempty (options)
    % {DEFAULT: full cylinder representation}
    options  = '-2l';
end

if (nargin < 7) || isempty (options)
    cmap = 'hsv_downtoned';
end

if nargin<8
    lw = 1;
end

if ~isempty      ([ ...
        (strfind (options, '-2')) ...
        (strfind (options, '-3'))])
    % if color values are mapped:
    if size (color, 1) > 1
        if size (color, 2) ~= 3
            if islogical (color)
                color  = double (color);
            end
            if nargin < 6 || isempty(crange)
            crange     = [(min (color)) (max (color))];
            end
            % scaling of the vector
            if diff (crange) == 0
                color  = ones (size (color, 1), 1);
            else
                color  = floor ( ...
                    (color - crange (1)) ./ ...
                    ((crange (2) - crange (1)) ./ 64));
                color (color <  1) =  1;
                color (color > 64) = 64;
            end
            map        = colormap(cmap);
            map = cat(1, map, [0 0 0]);
            blackIdx = isnan(color);
            color(blackIdx)= 65;
            color     = map (color, :);
        end
    end
    if ~isempty  ([ ...
            (strfind (options, '-2l')) ...
            (strfind (options, '-3l'))])
        if   strfind (options, '-2l')
            [X1, X2, Y1, Y2] = cyl_tree (intree, '-2d');
            HP         = line ( ...
                [(X1 (ipart)) (X2 (ipart))]' + DD (1), ...
                [(Y1 (ipart)) (Y2 (ipart))]' + DD (2));
        end
        if   strfind (options, '-3l')
            [X1, X2, Y1, Y2, Z1, Z2] = cyl_tree (intree);
            HP         = line ( ...
                [(X1 (ipart)) (X2 (ipart))]' + DD (1), ...
                [(Y1 (ipart)) (Y2 (ipart))]' + DD (2),...
                [(Z1 (ipart)) (Z2 (ipart))]' + DD (3));
        end
        if size (color, 1) > 1
            for counter   = 1 : length (ipart)
                set    (HP (counter), ...
                    'color',   color (counter, :), 'LineWidth', lw);
            end
        else
            set        (HP, ...
                'color',       color, 'LineWidth', lw);
        end
    end
  
end


if ~(sum (get (gca, 'DataAspectRatio') == [1 1 1]) == 3)
    axis         equal;
end



