
function skeletonlines = drawSkeleton ( varargin )
%
% Draws a skeleton from a skeleton struct.
%
% INPUT 
%   varies (see below)
%
% OUTPUT
%   skeletonlines ... handles to the created line elements
%
% skeletonlines = drawSkeleton ( skeleton, pose, coordsys )
% INPUT
%   skeleton ... skeleton structure
%   pose ....... 3 x #joints array containing the position of each joint
%                i.e. pose(1,2) is x coordinate of second joint
%   coordsys ... #joints x 1 cell array containing the local coordinate
%                system for each joint (correctly oriented to the pose)
%                each entry of the array contains a 3x3 matrix representing
%                the coordinate system.
%
% EXAMPLE
%   skeletonlines = drawSkeleton ( skeleton, pose )
%
%
% skeletonlines = drawSkeleton ( skeleton, motion, frame )
% INPUT
%   skeleton ... skeleton structure
%   motion ..... motion structure with calculated joint trajectories and
%                updated local coordinate systems
%   frame ...... frame number to get the pose from
%
% EXAMPLE
%   skeletonlines = drawSkeleton ( skeleton, motion, 3 )
%

%function skeletonlines = drawSkeleton ( skeleton, pose, coordsys )

% global GLOBAL_VARS_SETTINGS;

skeletonFromPose = true;

skeleton = varargin{1};

switch nargin
  case 1
    pose = [skeleton.joints(:).position];
    cs = [skeleton.joints(:).localcoordinatesystem];
    coordsys = mat2cell(cs, 3, ones(1, skeleton.numberofjoints)*3);
  case 2
    cs = [skeleton.joints(:).localcoordinatesystem];
    coordsys = mat2cell(cs, 3, ones(1, skeleton.numberofjoints)*3);
    pose = varargin{2};
  case 3
    if (length(varargin{3}) == 1)
      skeletonFromPose = false;
      motion = varargin{2};
      frame = varargin{3};
    else
      pose = varargin{2};
      coordsys = varargin{3};
    end
end % switch nargin




npaths = size(skeleton.paths,1);
% convert path node IDs to path node indices
idxpath = skeleton.paths;
for k=1:npaths
  for kk = 1:length(skeleton.paths{k})
    idxpath{k}(kk) = id2index(skeleton.namemap,skeleton.paths{k}(kk));
  end
end



   
% set line parameters
linewidth = 2; color=[0.15,0.15,0.15];
marker = 'o'; markersize=7; markerfacecolor = [0.75, 0.75, 0.75]; markeredgecolor = [0.5, 0.5, 0.5];

% initialize positions
lx = zeros(2,1);
ly = lx;
lz = lx;
skeletonlines = cell(1, npaths);

if skeletonFromPose
  %%%%% skeleton from pose %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % construct lines for all paths
  for k=1:npaths

    %path = skeleton.paths{k};
    path = idxpath{k};
    nlines = length(path)-1;

    % construct start point of first line
    idx = path(1);%id2index(skeleton.namemap,path(1));
    lx(1) = pose(1,idx);%skeleton.joints(idx).position(1);
    ly(1) = pose(2,idx);%skeleton.joints(idx).position(2);
    lz(1) = pose(3,idx);%skeleton.joints(idx).position(3);

    % construct lines in the current path
    for j=2:nlines
      idx = path(j);%id2index(skeleton.namemap,path(j));
      lx(2) = pose(1,idx);%skeleton.joints(idx).position(1);
      ly(2) = pose(2,idx);%skeleton.joints(idx).position(2);
      lz(2) = pose(3,idx);%skeleton.joints(idx).position(3);
      skeletonlines{k}(j-1) = line(lx,ly,lz,  ...
        'LineWidth', linewidth, ...
        'marker',marker, ...
        'Markersize',markersize, ...
        'MarkerFaceColor',markerfacecolor, ... 
        'MarkerEdgeColor',markeredgecolor, ...
        'Color',color);
      lx(1) = lx(2);
      ly(1) = ly(2);
      lz(1) = lz(2);
    end %for all but the first and last joint node

    % construct end point of last line
    idx = path(nlines+1);%id2index(skeleton.namemap,path(nlines+1));
    lx(2) = pose(1,idx);%skeleton.joints(idx).position(1);
    ly(2) = pose(2,idx);%skeleton.joints(idx).position(2);
    lz(2) = pose(3,idx);%skeleton.joints(idx).position(3);
    skeletonlines{k}(nlines) = line(lx,ly,lz,  ...
      'LineWidth', linewidth, ...
      'Marker',marker, ...
      'Markersize',markersize, ...
      'MarkerFaceColor',markerfacecolor, ... 
      'MarkerEdgeColor',markeredgecolor, ...
      'Color',color);

  end % for construct lines for all paths

  axiscolor = [...
    1.0,0.0,0.0; ... % x
    0.0,0.8,0.5; ... % y
    0.0,0.5,1.0; ... % z
    0.8,0.8,0.8 ...  % inactive
    ];

  % draw coordinate systems
%   for j=1:skeleton.numberofjoints
%     lx(1) = pose(1,j);%skeleton.joints(j).position(1);
%     ly(1) = pose(2,j);%skeleton.joints(j).position(2);
%     lz(1) = pose(3,j);%skeleton.joints(j).position(3);
%     for k=1:3
%       color = axiscolor(4,:);
%       %if (skeleton.joints(j).dof(k))
%         color = axiscolor(k,:);
%       %end
%       lx(2) = lx(1)+coordsys{j}(1,k)*10;%posx(1)+skeleton.joints(j).localcoordinatesystem(1,k)*10;
%       ly(2) = ly(1)+coordsys{j}(2,k)*10;%posx(1)+skeleton.joints(j).localcoordinatesystem(2,k)*10;
%       lz(2) = lz(1)+coordsys{j}(3,k)*10;%posx(1)+skeleton.joints(j).localcoordinatesystem(3,k)*10;
%       line(lx, ly, lz, 'LineWidth', linewidth+1, 'Color', color);
%     end
%   end % end for
  
else 
  %%%%% skeleton from frame %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % construct lines for all paths
  for k=1:npaths

    path = idxpath{k};%skeleton.paths{k};
    nlines = length(path)-1;

    % construct start point of first line
    lx(1) = motion.jointtrajectories{path(1)}(1,frame);
    ly(1) = motion.jointtrajectories{path(1)}(2,frame);
    lz(1) = motion.jointtrajectories{path(1)}(3,frame);

    % construct lines in the current path
    for j=2:nlines
      lx(2) = motion.jointtrajectories{path(j)}(1,frame);
      ly(2) = motion.jointtrajectories{path(j)}(2,frame);
      lz(2) = motion.jointtrajectories{path(j)}(3,frame);
      skeletonlines{k}(j-1) = line(lx,ly,lz, ...
        'LineWidth', linewidth, ...
        'Marker',marker, ...
        'Markersize',markersize, ...
        'MarkerFaceColor',markerfacecolor, ... 
        'MarkerEdgeColor',markeredgecolor, ...
        'Color',color);
      lx(1) = lx(2);
      ly(1) = ly(2);
      lz(1) = lz(2);
    end %for all but the first and last joint node

    % construct end point of last line
    lx(2) = motion.jointtrajectories{path(nlines+1)}(1,frame);
    ly(2) = motion.jointtrajectories{path(nlines+1)}(2,frame);
    lz(2) = motion.jointtrajectories{path(nlines+1)}(3,frame);
    skeletonlines{k}(nlines) = line(lx,ly,lz,  ...
      'LineWidth', linewidth, ...
      'Marker',marker, ...
      'Markersize',markersize, ...
      'MarkerFaceColor',markerfacecolor, ... 
      'MarkerEdgeColor',markeredgecolor, ...
      'Color',color);

    %%%%%% START draw coordinate system
    % drawCoordinateSystemFromFrame ( skeleton, motion, linewidth, frame ); 
    %%%%%% END draw coordinate system
  end % for construct lines for all paths
  
end % fi skeletonFromPose



  %%
  function drawCoordinateSystemFromFrame ( skeleton, motion, linewidth, frame )
    
    axcol = [...
      1.0,0.0,0.0; ... % x
      0.0,0.8,0.5; ... % y
      0.0,0.5,1.0; ... % z
      0.8,0.8,0.8 ...  % inactive
      ];

    thepose = frame2pose(motion, frame);
    lcs = thepose.lcs;
    thepose = thepose.pos;
    % draw coordinate systems
    for fj=1:skeleton.numberofjoints
      flx(1) = thepose(1,fj);%skeleton.joints(j).position(1);
      fly(1) = thepose(2,fj);%skeleton.joints(j).position(2);
      flz(1) = thepose(3,fj);%skeleton.joints(j).position(3);
      for fk=1:3
        c = axcol(4,:);
        if (skeleton.joints(fj).dof(fk))
          c = axcol(fk,:);
        end
        flx(2) = flx(1)+lcs{fj}(1,fk)*10;%posx(1)+skeleton.joints(j).localcoordinatesystem(1,k)*10;
        fly(2) = fly(1)+lcs{fj}(2,fk)*10;%posx(1)+skeleton.joints(j).localcoordinatesystem(2,k)*10;
        flz(2) = flz(1)+lcs{fj}(3,fk)*10;%posx(1)+skeleton.joints(j).localcoordinatesystem(3,k)*10;
        line(flx, fly, flz, 'LineWidth', linewidth+1, 'Color', c);
      end % end go through joints
    end % end for go through dimensions
    
  end % of function  drawCoordinateSystemFromFrame

end % of function drawSkeleton

%%% Line Options
%'Color',color,
%'LineWidth',linewidth,
%'linestyle',linestyle,
%'Parent',gca,
%'marker',marker,
%'markersize',markersize,
%'markeredgecolor',markeredgecolor,
%'markerfacecolor',markerfacecolor,
%%%%%%%%%%%%%%%%

