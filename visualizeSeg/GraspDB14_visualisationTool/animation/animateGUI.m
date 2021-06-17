function varargout = animateGUI(varargin)
% [ fig_handle ] = animateGUI(skeleton_struct, motion_struct)
% 
% ANIMATEGUI MATLAB code for animateGUI.fig
%      ANIMATEGUI, by itself, creates a new ANIMATEGUI or raises the existing
%      singleton*.
%
%      H = ANIMATEGUI returns the handle to a new ANIMATEGUI or the handle to
%      the existing singleton*.
%
%      ANIMATEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANIMATEGUI.M with the given input arguments.
%
%      ANIMATEGUI('Property','Value',...) creates a new ANIMATEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before animateGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to animateGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% 
% EXAMPLE
%   animateGUI(skel, mot(6));

% Edit the above text to modify the response to help animateGUI

% Last Modified by GUIDE v2.5 16-Nov-2017 13:57:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @animateGUI_OpeningFcn_local, ...
                   'gui_OutputFcn',  @animateGUI_OutputFcn_local, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%hSlider = uicontrol('Style','slider','Callback',@(s,e) disp('hello'));
end % of function animateGUI

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes just before animateGUI is made visible.
function animateGUI_OpeningFcn_local(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to animateGUI (see VARARGIN)

% Choose default command line output for animateGUI
handles.output = hObject;


if isempty(varargin)
  [varargin{1}, varargin{2}] = animateGUI_loaddefault_local;
end

handles.skeleton = varargin{1};
handles.motion = varargin{2};



numberofframes = handles.motion.numberofframes;
step = 1/numberofframes;
set(handles.slider_animateGUI, ...
  'Min', 1, ...
  'Max', numberofframes, ...
  'Value', 1, ...
  'SliderStep', [step step] );

hListener = addlistener(handles.slider_animateGUI,'Value','PostSet',@(src,evnt)slider_animateGUI_Callback(handles.slider_animateGUI, [], handles) );
% deactivate everything
set(handles.slider_animateGUI, 'Enable', 'off');
set(handles.pushbutton_animateGUI_exit, 'Enable', 'off');
set(handles.axes_animateGUI, 'Visible', 'off');
set(handles.pushbutton_animateGUI_play, 'Enable', 'off');
set(handles.pushbutton_animateGUI_pause, 'Enable', 'off');

% Update handles structure
guidata(hObject, handles);


animateGUI_startanimation_local ( handles );
end % of function animateGUI_OpeningFcn_local
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% UIWAIT makes animateGUI wait for user response (see UIRESUME)
% uiwait(handles.animateGUI_figure);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Outputs from this function are returned to the command line.
function varargout = animateGUI_OutputFcn_local(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end % of function animateGUI_OutputFcn_local
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on slider movement.
function slider_animateGUI_Callback(hObject, eventdata, handles)
% hObject    handle to slider_animateGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global GLOBAL_VARS_ANIMATE

current_frame = round(get(hObject,'Value'));
GLOBAL_VARS_ANIMATE.currentframe = current_frame;
animateGUI_showframe_local(handles, current_frame );
end % of function slider_animateGUI_Callback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes during object creation, after setting all properties.
function slider_animateGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_animateGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end % of function slider_animateGUI_CreateFcn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton_animateGUI_exit.
function pushbutton_animateGUI_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_animateGUI_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

t = timerfind ( 'Name', 'animateGUI_HandAnimationTimer' );
if ( ~isempty(t) )
  delete(t);
end
delete(gcf);
end % of function pushbutton_animateGUI_exit_Callback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [skel, mot] = animateGUI_loaddefault_local

  path_skel = '/home/kstoll2m/PhD/hative/motionplayer/doc/';
  path_db = '/home/kstoll2m/PhD/native/db-ks/';
  if ispc
    path_skel = 'D:\PhD\hative\motionplayer\doc\';
    path_db = 'D:\PhD\native\db-ks\';
  end
  skel = readSkeleton ( strcat(path_skel, filesep, 'default.xmlskel') ); 
  skel = constructPalm ( skel );
  mot = loadDBKSmotion ( strcat(path_db, filesep, 'data', filesep, 'ex01', filesep, 'rad', filesep, '01_ex01-rad-002-grasp-su01.txt'), 'full' );
  %mot = loadDBKSmotion ( strcat(path_db, filesep, 'data', filesep, 'ex01', filesep, 'rad', filesep, '01_ex01-rad-002-grasp-su01.txt'), 'fixed-root' );
end % of function animateGUI_loaddefault_local
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function animateGUI_startanimation_local ( handles )
  % start animation
  global GLOBAL_VARS_ANIMATE;
  % prepare animation controls
  numberofframes = handles.motion.numberofframes;
  step = 1/numberofframes;
  set(handles.slider_animateGUI, ...
    'Enable','on',...
    'Min', 1, ...
    'Max', numberofframes, ...
    'Value', 1, ...
    'SliderStep', [step step] );
  set(handles.pushbutton_animateGUI_exit, 'Enable', 'on');
  set(handles.pushbutton_animateGUI_play, 'Enable', 'on');
  set(handles.pushbutton_animateGUI_pause, 'Enable', 'on');

  % reload if GLOBAL_VARS_ANGLEDATAPLOT is not yet existant or
  % if the variant has changed.
  if isempty(GLOBAL_VARS_ANIMATE)
    GLOBAL_VARS_ANIMATE.skelcolor = zeros(handles.motion.numberofframes, 3);
  elseif size(GLOBAL_VARS_ANIMATE.skelcolor,1) ~= handles.motion.numberofframes
    GLOBAL_VARS_ANIMATE.skelcolor = zeros(handles.motion.numberofframes, 3);
  end
  
  % color appropriate to annotation if there is one
  mot_annot = loadDBKSmotion_annotation(handles.motion.filename);
  if ~isempty(mot_annot)
    seg =  [[1 mot_annot.cutsm]'  [mot_annot.cutsm+1 mot_annot.num_frames]'];
    colors = colormap('lines');
    for k=1:numel(seg)/2
      nframes = length(seg(k,1):seg(k,2));
      GLOBAL_VARS_ANIMATE.skelcolor(seg(k,1):seg(k,2),:) = repmat(colors(k,:), nframes,1);
    end
  end

  % set current axis and figure;
  fig = gcf;
  currentax = handles.axes_animateGUI;
  cla(currentax, 'reset');
  set(handles.axes_animateGUI, 'Visible', 'on');
  set(fig, 'CurrentAxes', currentax);

  cameratoolbar;
  cameratoolbar('Hide');
  cameratoolbar('SetCoordSys','z');

  filedescr = filename2description(handles.motion.filename);

  % generate and set title
  figure_title = [...
    'Scenario No. ', num2str(filedescr.experiment), ...
    ', Object: ', num2str(filedescr.object), ...
    ', Action: ', filedescr.action, ...
    ', Hand: ', filedescr.hand, ...
    ', ID: ', sprintf('%d-%02d-%02d (ex-su-obj)\n%s', filedescr.experiment, filedescr.subjectid, filedescr.objectid, handles.motion.filename) ...
    ];
  set(handles.text_animateGUI_filedescr, 'String', figure_title);

  % construct bounding box for motion and adjust axis accordingly
  aabb = computeAABB(handles.motion.jointtrajectories, '3dpositions');
  tilesize = 20;
  [h, aabb] = createWalls(aabb(:)'+repmat([-1,1]*tilesize,1,3),tilesize);
  set(h(1), 'Visible', 'off');
  set(h(2), 'Visible', 'off');
  axeslimits = aabb+repmat([-1,1],1,3);
  axis(currentax, axeslimits );
  set( currentax, 'Color', 'white' );
  grid on;
  camtarget =  [aabb(1)+aabb(2) aabb(3)+aabb(4) aabb(5)+aabb(6)]/2;
  campos = camtarget+[200 60 100]*4;
  xticks = round(axeslimits(1)/tilesize)*tilesize:tilesize:round(axeslimits(2)/tilesize)*tilesize;
  yticks = round(axeslimits(3)/tilesize)*tilesize:tilesize:round(axeslimits(4)/tilesize)*tilesize;
  zticks = round(axeslimits(5)/tilesize)*tilesize:tilesize:round(axeslimits(6)/tilesize)*tilesize;
  set( currentax,...
    'XTick', xticks, ...
    'YTick', yticks, ...
    'ZTick', zticks, ...
    'CameraTarget',  camtarget, ...
    'CameraPosition', campos, ...
    'CameraViewAngle', 15, ...
    'Projection','perspective');

  GLOBAL_VARS_ANIMATE.skeleton = handles.skeleton;
  GLOBAL_VARS_ANIMATE.motion = handles.motion;
  GLOBAL_VARS_ANIMATE.currentframe = round(get(handles.slider_animateGUI, 'Value'));
  GLOBAL_VARS_ANIMATE.skeletonlines_idxpaths = convertSkeletonPath(handles.skeleton, 'id2index');
  GLOBAL_VARS_ANIMATE.skeletonlines = drawSkeleton ( handles.skeleton, handles.motion, GLOBAL_VARS_ANIMATE.currentframe );
  GLOBAL_VARS_ANIMATE.patchaabb = h;
  GLOBAL_VARS_ANIMATE.animation_paused = true;
  GLOBAL_VARS_ANIMATE.frametime = 1/GLOBAL_VARS_ANIMATE.motion.samplingrate;
  % remove warning on timer period being limited to 1 millisecond precision
  GLOBAL_VARS_ANIMATE.frametime = floor(GLOBAL_VARS_ANIMATE.frametime*1000)/1000;
  GLOBAL_VARS_ANIMATE.loop_playback = get(handles.checkbox_animateGUI_repeat,'Value');

  t = timer ( 'Name', 'animateGUI_HandAnimationTimer' );
  set( t, ...
    'TimerFcn',{@cb_draw_local,handles}, ...
    'StopFcn', @cb_on_timer_stop_local, ...
    'ExecutionMode','fixedRate',...
    'Period',GLOBAL_VARS_ANIMATE.frametime,...
    'TasksToExecute', (GLOBAL_VARS_ANIMATE.motion.numberofframes)-GLOBAL_VARS_ANIMATE.currentframe+1);

end % of function animateGUI_startanimation_local
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cb_on_timer_stop_local (~,~)

  global GLOBAL_VARS_ANIMATE;
  GLOBAL_VARS_ANIMATE.animation_paused = true;
  if GLOBAL_VARS_ANIMATE.loop_playback
    t = timerfind('Name','animateGUI_HandAnimationTimer');
    start(t);
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cb_draw_local ( varargin ) % (obj, event)
  global GLOBAL_VARS_ANIMATE;
  hObject = varargin{3};
  if(GLOBAL_VARS_ANIMATE.currentframe < GLOBAL_VARS_ANIMATE.motion.numberofframes)
    GLOBAL_VARS_ANIMATE.currentframe = GLOBAL_VARS_ANIMATE.currentframe+1;
  else
    GLOBAL_VARS_ANIMATE.currentframe = 1;
    set(hObject.slider_animateGUI,'Value', GLOBAL_VARS_ANIMATE.currentframe);
    return
  end
  animateGUI_showframe_local(hObject);
  set(hObject.slider_animateGUI,'Value', GLOBAL_VARS_ANIMATE.currentframe);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function animateGUI_showframe_local ( varargin )% hObject, frame )

  global GLOBAL_VARS_ANIMATE;
  
  hObject = varargin{1};
  
  if numel(varargin) == 1
    frame = GLOBAL_VARS_ANIMATE.currentframe;
  else
    frame = varargin{2};
  end

  set(hObject.text_animateGUI_frameno, 'String', ['frame ' num2str(frame)]);

  % initialize variables holding x-, y- and z-positions of lines
  lx = zeros(2,1);
  ly = lx;
  lz = lx;
  % shorten some names
  motion = GLOBAL_VARS_ANIMATE.motion;
  idxpath = GLOBAL_VARS_ANIMATE.skeletonlines_idxpaths;
  skeletonlines = GLOBAL_VARS_ANIMATE.skeletonlines;
  
  skelcolor = GLOBAL_VARS_ANIMATE.skelcolor(frame,:);
  npaths = length(GLOBAL_VARS_ANIMATE.skeletonlines_idxpaths);
  for p=1:npaths
    currpath = idxpath{p};
    nlines = length(currpath)-1;
    % very first start point 
    lx(1) = motion.jointtrajectories{currpath(1)}(1,frame);
    ly(1) = motion.jointtrajectories{currpath(1)}(2,frame);
    lz(1) = motion.jointtrajectories{currpath(1)}(3,frame);
    for n=2:nlines
      lx(2) = motion.jointtrajectories{currpath(n)}(1,frame);
      ly(2) = motion.jointtrajectories{currpath(n)}(2,frame);
      lz(2) = motion.jointtrajectories{currpath(n)}(3,frame);
      set ( skeletonlines{p}(n-1), 'XData', lx, 'YData', ly, 'ZData', lz, 'Color', skelcolor);
      % end point of current line is start point of next line
      lx(1) = lx(2);
      ly(1) = ly(2);
      lz(1) = lz(2);
    end
    % end point of last line 
    lx(2) = motion.jointtrajectories{currpath(nlines+1)}(1,frame);
    ly(2) = motion.jointtrajectories{currpath(nlines+1)}(2,frame);
    lz(2) = motion.jointtrajectories{currpath(nlines+1)}(3,frame);
    set ( skeletonlines{p}(nlines), 'XData', lx, 'YData', ly, 'ZData', lz, 'Color', skelcolor);
  end % for paths
end % of function animateGUI_showframe_local 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in checkbox_animateGUI_hideline.
function checkbox_animateGUI_hideline_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_animateGUI_hideline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_animateGUI_hideline

global GLOBAL_VARS_ANIMATE;
skeletonlines = GLOBAL_VARS_ANIMATE.skeletonlines;
if get(hObject, 'Value')
  for k=1:size(skeletonlines,2)
    set(skeletonlines{k}, 'LineStyle', 'none');
  end
else
  for k=1:size(skeletonlines,2)
    set(skeletonlines{k}, 'LineStyle', '-');
  end
  set(handles.checkbox_animateGUI_hidetips, 'Value', 0);
end
end % of function checkbox_animateGUI_hideline_Callback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in checkbox_animateGUI_hidedot.
function checkbox_animateGUI_hidedot_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_animateGUI_hidedot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_animateGUI_hidedot

global GLOBAL_VARS_ANIMATE;
skeletonlines = GLOBAL_VARS_ANIMATE.skeletonlines;
if get(hObject, 'Value')
  for k=1:size(skeletonlines,2)
    set(skeletonlines{k}, 'Marker', 'none');
  end
else
  for k=1:size(skeletonlines,2)
    set(skeletonlines{k}, 'Marker', 'o');
  end
end
end % of function checkbox_animateGUI_hidedot_Callback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in checkbox_animateGUI_hidetips.
function checkbox_animateGUI_hidetips_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_animateGUI_hidetips (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_animateGUI_hidetips

global GLOBAL_VARS_ANIMATE;
skeletonlines = GLOBAL_VARS_ANIMATE.skeletonlines;
% {1} th {2} if {3} mf {4} rf {5} lf {6} palm
if get(hObject, 'Value')
  for k=2:size(skeletonlines,2)-1
    set(skeletonlines{k}(end), 'LineStyle', 'none');
    set(skeletonlines{k}(end), 'Marker', 'none');
  end
else
  for k=2:size(skeletonlines,2)-1
    set(skeletonlines{k}(end), 'LineStyle', '-');
    set(skeletonlines{k}(end), 'Marker', 'o');
  end
end
end % of function checkbox_animateGUI_hidetips_Callback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in checkbox_animateGUI_hidefloor.
function checkbox_animateGUI_hidefloor_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_animateGUI_hidefloor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_animateGUI_hidefloor

global GLOBAL_VARS_ANIMATE;
if get(hObject, 'Value')
  set(GLOBAL_VARS_ANIMATE.patchaabb(3), 'visible', 'off');
else
  set(GLOBAL_VARS_ANIMATE.patchaabb(3), 'visible', 'on');
end

end % of function checkbox_animateGUI_hidefloor_Callback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%get(skeletonlines,'XData')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton_animateGUI_play.
function pushbutton_animateGUI_play_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_animateGUI_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global GLOBAL_VARS_ANIMATE;

frame = round(get(handles.slider_animateGUI,'Value'));
max_frame = round(get(handles.slider_animateGUI,'Max'));

if GLOBAL_VARS_ANIMATE.animation_paused
  t = timerfind('Name','animateGUI_HandAnimationTimer');

  if (frame == max_frame)
    GLOBAL_VARS_ANIMATE.currentframe = 1;
  end

  try
    if(~isempty(t))
      t = t(1);
      num_frames = max_frame - frame +1;
      set(t,'TasksToExecute',num_frames);
      %GLOBAL_VARS_ANIMATE.currentframe = frame;

      start(t);
    end
  catch
    delete(t);
    return
  end
  GLOBAL_VARS_ANIMATE.animation_paused = false;
end

end % of function pushbutton_play_Callback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton_animateGUI_pause.
function pushbutton_animateGUI_pause_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_animateGUI_pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global GLOBAL_VARS_ANIMATE;

t = timerfind('Name','animateGUI_HandAnimationTimer');
if(~isempty(t))
  t = t(1);
  GLOBAL_VARS_ANIMATE.loop_playback = false;
  stop(t);
  wait(t);

  
  GLOBAL_VARS_ANIMATE.loop_playback = get(handles.checkbox_animateGUI_repeat,'Value');
  GLOBAL_VARS_ANIMATE.animation_paused = true;
end
end % of function pushbutton_pause_Callback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in checkbox_animateGUI_repeat.
function checkbox_animateGUI_repeat_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_animateGUI_repeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_animateGUI_repeat
global GLOBAL_VARS_ANIMATE
GLOBAL_VARS_ANIMATE.loop_playback = get(hObject,'Value');
if ~GLOBAL_VARS_ANIMATE.loop_playback
  t = timerfind('Name','animateGUI_HandAnimationTimer');
  num_frames = GLOBAL_VARS_ANIMATE.motion.numberofframes - GLOBAL_VARS_ANIMATE.currentframe +1;
  wait(t);
  set(t,'TasksToExecute',num_frames);
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% --- Executes on key press with focus on animateGUI_figure or any of its controls.
function animateGUI_figure_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to animateGUI_figure (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
  case 's'
    %disp('pressed s');
    saveAsPNG_ks (handles.animateGUI_figure, ['animateGUI']);
    %color_old = get(handles.text_animateGUI_frameno, 'BackgroundColor');
    %set( handles.text_animateGUI_frameno, 'BackgroundColor', [1 1 1] );
    rgb2cm;
    clear cm j i c n patches;
    saveAsPDF_ks (handles.animateGUI_figure, ['animateGUI'], false);
    %set( handles.text_animateGUI_frameno, 'BackgroundColor', color_old );
  otherwise
    %disp(['unsupported key, ' eventdata.Key]);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
