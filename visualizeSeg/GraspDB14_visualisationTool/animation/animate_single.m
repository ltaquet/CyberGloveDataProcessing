
function fig = animate ( g_skeleton, g_motion, numloops )
%
% Animate skeleton according to a motion. Uses a timer function.
%
% INPUT
%   skeleton ... skeleton struct
%   motion ..... motion struct
%   numloops ... (optional) number of loops to play the motion sequence
%                default is one.
%
% OUTPUT
%   fig ... handle to the figure that was drawn into
%
% EXAMPLE
%   animate ( skeleton, motion );
%
%

global GLOBAL_VARS_ANIMATE;
% reload if GLOBAL_VARS_ANGLEDATAPLOT is not yet existant or
% if the variant has changed.
% if isempty(GLOBAL_VARS_ANIMATE)
  GLOBAL_VARS_ANIMATE.skelcolor = zeros(g_motion.numberofframes, 3);
% elseif size(GLOBAL_VARS_ANIMATE.skelcolor,1) ~= g_motion.numberofframes
%   GLOBAL_VARS_ANIMATE.skelcolor = zeros(g_motion.numberofframes, 3);
% end
mot_annot = loadDBKSmotion_annotation(g_motion.filename);
if ~isempty(mot_annot)
  seg =  [[1 mot_annot.cutsm]'  [mot_annot.cutsm+1 mot_annot.num_frames]'];
  colors = colormap('lines');close(1);
  for k=1:numel(seg)/2
    nframes = length(seg(k,1):seg(k,2));
    GLOBAL_VARS_ANIMATE.skelcolor(seg(k,1):seg(k,2),:) = repmat(colors(k,:), nframes,1);
  end
end


if nargin == 2
  numloops = 1;
end

%
% set up figure with a handle to deleting the timer when the figure is
% closed
fig = figure( 'DeleteFcn', @cb_closefigure_local );
currentax = axes('Parent',fig);

filedescr = filename2description(g_motion.filename);

figure_titel = [...
  'Scenario No. ', num2str(filedescr.experiment), ...
  ', Object: ', num2str(filedescr.object), ...
  ', Action: ', filedescr.action, ...
  ', Hand: ', filedescr.hand, ...
  ', ID: ', sprintf('%d-%02d-%02d', filedescr.experiment, filedescr.subjectid, filedescr.objectid) ...
  ];


%
% construct bounding box for motion and adjust axis accordingly
aabb = computeAABB(g_motion.jointtrajectories, '3dpositions');
[walls, aabb] = createWalls(aabb(:)'+repmat([-1,1]*25,1,3),25);
axis(currentax, aabb+repmat([-1,1],1,3) );
set( currentax, 'view', [120,40] );
set( currentax, 'Color', 'none' );
title(figure_titel);

g_npaths = size(g_skeleton.paths, 1);
% convert path node IDs to path node indices
g_idxpath = g_skeleton.paths;
for k=1:g_npaths
  for kk = 1:length(g_skeleton.paths{k})
    g_idxpath{k}(kk) = id2index(g_skeleton.namemap,g_skeleton.paths{k}(kk));
  end
end


% initialize variables holding x-, y- and z-positions of lines
g_lx = zeros(2,1);
g_ly = g_lx;
g_lz = g_lx;

% initialize skeleton line structure
g_frame = 1;
g_skeletonlines = drawSkeleton ( g_skeleton, g_motion, g_frame );
g_texthandle = text(0,0,0,'');
set(g_texthandle,'interpreter','none');

% set frame time (inverse of frame rate)
frametime = 1/g_motion.samplingrate;
% remove warning on timer period being limited to 1 millisecond precision
frametime = floor(frametime*1000)/1000;

% cleanup old timer (if any) and create new one
t = timerfind(  'Name', 'animateSingle_HandAnimationTimer' );
if ( ~isempty(t) )
  stop(t);
  delete(t);
end
t = timer ( 'Name', 'animateSingle_HandAnimationTimer' );
set( t, ...
  'TimerFcn',@cb_draw_local, ...
  'ExecutionMode','fixedRate',...
  'Period',frametime,...
  'TasksToExecute', (g_motion.numberofframes*numloops)-g_frame+1);

start(t);
%wait(t)

%GLOBAL_VARS_ANIMATE.skelcolor = zeros(g_motion.numberofframes, 3);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% callback function for updating the hand display
  function cb_draw_local ( ~, ~ ) % (obj, event)
    animate_updateFrame_local
    g_frame = g_frame+1;
  end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% callback function for deleting the timer on closing the figure
  function cb_closefigure_local ( ~, ~ ) % (obj, event)
    timer_cleanup;
    %stop(t);
    %delete(t);
  end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% callback function for deleting the timer on closing the figure
function timer_cleanup
  t = timerfind(  'Name', 'animateSingle_HandAnimationTimer' );
  if ( ~isempty(t) )
    stop(t);
    delete(t);
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% update skeleton line setup for each frame
  function animate_updateFrame_local 
    frame = mod(g_frame-1, g_motion.numberofframes)+1;
    skelcolor = GLOBAL_VARS_ANIMATE.skelcolor(frame,:);
    for p=1:g_npaths
      currpath = g_idxpath{p};
      nlines = length(currpath)-1;
      % very first start point 
      g_lx(1) = g_motion.jointtrajectories{currpath(1)}(1,frame);
      g_ly(1) = g_motion.jointtrajectories{currpath(1)}(2,frame);
      g_lz(1) = g_motion.jointtrajectories{currpath(1)}(3,frame);
      for n=2:nlines
        g_lx(2) = g_motion.jointtrajectories{currpath(n)}(1,frame);
        g_ly(2) = g_motion.jointtrajectories{currpath(n)}(2,frame);
        g_lz(2) = g_motion.jointtrajectories{currpath(n)}(3,frame);
        set ( g_skeletonlines{p}(n-1), 'XData', g_lx, 'YData', g_ly, 'ZData', g_lz, 'Color', skelcolor);
        % end point of current line is start point of next line
        g_lx(1) = g_lx(2);
        g_ly(1) = g_ly(2);
        g_lz(1) = g_lz(2);
      end
      % end point of last line 
      g_lx(2) = g_motion.jointtrajectories{currpath(nlines+1)}(1,frame);
      g_ly(2) = g_motion.jointtrajectories{currpath(nlines+1)}(2,frame);
      g_lz(2) = g_motion.jointtrajectories{currpath(nlines+1)}(3,frame);
      set ( g_skeletonlines{p}(nlines), 'XData', g_lx, 'YData', g_ly, 'ZData', g_lz, 'Color', skelcolor);
    end % for paths
    set(g_texthandle, ...
      'String', sprintf('    frame %03d', frame), ...
      'Position', g_motion.jointtrajectories{1}(:,frame));
  end % of function drawFrame
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end %of function animate