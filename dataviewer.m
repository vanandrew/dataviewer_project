function varargout = dataviewer(varargin)
% DATAVIEWER MATLAB code for dataviewer.fig
%      DATAVIEWER, by itself, creates a new DATAVIEWER or raises the existing
%      singleton*.
%
%      H = DATAVIEWER returns the handle to a new DATAVIEWER or the handle to
%      the existing singleton*.
%
%      DATAVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATAVIEWER.M with the given input arguments.
%
%      DATAVIEWER('Property','Value',...) creates a new DATAVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dataviewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dataviewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dataviewer

% Last Modified by GUIDE v2.5 01-Aug-2013 13:46:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dataviewer_OpeningFcn, ...
                   'gui_OutputFcn',  @dataviewer_OutputFcn, ...
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


% --- Executes just before dataviewer is made visible.
function dataviewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dataviewer (see VARARGIN)

% clc
clc;

% Open logo
img = imread('NINDS_logo.png');
axes(handles.axes2);
imshow(img);

% Choose default command line output for dataviewer
handles.output = hObject;

% Set String; Get String
handles.setstr = @(data,str) set(data, 'String', str);
handles.getstr = @(data) get(data, 'String');

% Set Value; Get Value
handles.setval = @(data,val) set(data, 'Value', val);
handles.getval = @(data) get(data, 'Value');

% Define handles.realamp
handles.realamp = {};

% Define handles.voxellist
handles.voxellist = [];

% Set listbox3 value to 0
handles.setval(handles.listbox3, 0);

% Define handles.num
handles.num = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dataviewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dataviewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Return filename + path

% Clear voxellist
handles.voxellist = [];
handles.setstr(handles.listbox3, handles.voxellist);

% Get files
[filename, pathname, fi] = uigetfile({'*.txt';}, 'File Selector',...
    'MultiSelect', 'on');

if fi == 0
    % No files opened
    disp('#0 Files Processed.');
    handles.setstr(handles.listbox2, cmdwinout());
    return;
end

% If filename not cell array, make cell array
if ~iscell(filename)
    filename = {filename};
end

% Sort filenames
filename = sort(filename);

% Find the number of files opened
handles.num = size(filename ,2);

if (handles.num ~= 16)
    warning = ['#WARNING: Number of files is not 16;'...
        ' Layer indexing will not be correct.'];
    warning2 = '#Out of bound errors may occur.';
    disp(warning);
    disp(warning2);
    handles.setstr(handles.listbox2, cmdwinout());
end

% Define anonymous functions for extracting data
getfreq = @(var) var.freq;
getfreqsd = @(var) var.freqsd;
getamp = @(var) var.amp;
getampsd = @(var) var.ampsd;
getdamp = @(var) var.damp;

% Allocate cell space for data
handles.freq = cell(1,handles.num);
handles.freqsd = cell(1,handles.num);
handles.amp = cell(1,handles.num);
handles.ampsd = cell(1,handles.num);
handles.damp = cell(1,handles.num);
handles.realamp = cell(1,handles.num);

for i=1:handles.num
    % Collect data from file i
    data = resultloader(pathname, filename{i});

    % Retrieve frequency from file i
    handles.freq{i} = [getfreq(data.PCR), getfreq(data.ALPHAATP),...
        getfreq(data.GAMMAATP), getfreq(data.PE),...
        getfreq(data.PC), getfreq(data.GPE),...
        getfreq(data.GPC), getfreq(data.PI1)];

    % Retrieve SD frequency from file i
    handles.freqsd{i} = [getfreqsd(data.PCR), getfreqsd(data.ALPHAATP),...
        getfreqsd(data.GAMMAATP), getfreqsd(data.PE),...
        getfreqsd(data.PC), getfreqsd(data.GPE),...
        getfreqsd(data.GPC), getfreqsd(data.PI1)];

    % Retrieve amplitude from file i
    handles.amp{i} = [getamp(data.PCR), getamp(data.ALPHAATP),...
        getamp(data.GAMMAATP), getamp(data.PE),...
        getamp(data.PC), getamp(data.GPE),...
        getamp(data.GPC), getamp(data.PI1)];

    % Retrieve SD amplitude from file i
    handles.ampsd{i} = [getampsd(data.PCR), getampsd(data.ALPHAATP),...
        getampsd(data.GAMMAATP), getampsd(data.PE),...
        getampsd(data.PC), getampsd(data.GPE),...
        getampsd(data.GPC), getampsd(data.PI1)];

    % Retrieve damping from file i
    handles.damp{i} = (-1)*[getdamp(data.PCR), getdamp(data.ALPHAATP),...
        getdamp(data.GAMMAATP), getdamp(data.PE),...
        getdamp(data.PC), getdamp(data.GPE),...
        getdamp(data.GPC), getdamp(data.PI1)];

    % Calculate real amplitude from amplitude and damping
    handles.realamp{i} = handles.amp{i}./handles.damp{i};
end

% Display # of files processed
disp(['#' num2str(handles.num) ' Files Processed.']);
handles.setstr(handles.listbox2, cmdwinout());

% Display Amplitude of first Siemens first voxel
handles.sv = 245;
handles.setval(handles.radiobutton1,0);
handles.setval(handles.radiobutton2,0);
handles.setval(handles.radiobutton3,0);
handles.setval(handles.radiobutton4,0);
handles.setval(handles.radiobutton6,1);
handles.setval(handles.radiobutton7,0);
handles.setval(handles.radiobutton8,0);
handles.setval(handles.radiobutton9,0);
handles.setstr(handles.edit9, num2str(handles.sv));
[handles.n, handles.v] = siemens2jmrui(handles.sv);
handles.setstr(handles.edit10, num2str(handles.n));
handles.setstr(handles.edit11, num2str(handles.v));
handles.setstr(handles.edit1, num2str(handles.realamp{handles.n}(handles.v+1,1)));
handles.setstr(handles.edit2, num2str(handles.realamp{handles.n}(handles.v+1,2)));
handles.setstr(handles.edit3, num2str(handles.realamp{handles.n}(handles.v+1,3)));
handles.setstr(handles.edit4, num2str(handles.realamp{handles.n}(handles.v+1,4)));
handles.setstr(handles.edit5, num2str(handles.realamp{handles.n}(handles.v+1,5)));
handles.setstr(handles.edit6, num2str(handles.realamp{handles.n}(handles.v+1,6)));
handles.setstr(handles.edit7, num2str(handles.realamp{handles.n}(handles.v+1,7)));
handles.setstr(handles.edit8, num2str(handles.realamp{handles.n}(handles.v+1,8)));

% Update handles structure
guidata(hObject, handles);

function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double

% Check if file is open
if handles.num == 0
    return;
end

% Get siemens voxel #
handles.sv = str2double(handles.getstr(handles.edit9));
if (handles.sv >= 1 && handles.sv <= 4096 && ~isnan(handles.sv))
    [handles.n, handles.v] = siemens2jmrui(handles.sv);
    handles.setstr(handles.edit10, num2str(handles.n));
    handles.setstr(handles.edit11, num2str(handles.v));
    
    % Save voxel number
    if isempty(handles.voxellist)
        handles.voxellist = {num2str(handles.sv)};
    else
        handles.voxellist = [{num2str(handles.sv)}; handles.voxellist];
    end
    handles.setval(handles.listbox3, 1);
    handles.setstr(handles.listbox3, handles.voxellist);
else
    disp('#Voxel number outside dataset range');
    handles.setstr(handles.listbox2, cmdwinout());
    handles.n = 1; handles.v = 0;    
end

% Display voxel data
handles.setstr(handles.edit10, num2str(handles.n));
handles.setstr(handles.edit11, num2str(handles.v));
handles.setstr(handles.edit1, num2str(handles.realamp{handles.n}(handles.v+1,1)));
handles.setstr(handles.edit2, num2str(handles.realamp{handles.n}(handles.v+1,2)));
handles.setstr(handles.edit3, num2str(handles.realamp{handles.n}(handles.v+1,3)));
handles.setstr(handles.edit4, num2str(handles.realamp{handles.n}(handles.v+1,4)));
handles.setstr(handles.edit5, num2str(handles.realamp{handles.n}(handles.v+1,5)));
handles.setstr(handles.edit6, num2str(handles.realamp{handles.n}(handles.v+1,6)));
handles.setstr(handles.edit7, num2str(handles.realamp{handles.n}(handles.v+1,7)));
handles.setstr(handles.edit8, num2str(handles.realamp{handles.n}(handles.v+1,8)));

% Update handles structure
guidata(hObject, handles);

function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

% Check if file is open
if handles.num == 0
    return;
end

% Get jMRUI layer #
handles.n = str2double(handles.getstr(handles.edit10));
handles.v = str2double(handles.getstr(handles.edit11));
if (handles.n >= 1 && handles.n <= 16 && ~isnan(handles.n))
    handles.sv = jmrui2siemens(handles.n, handles.v);
    handles.setstr(handles.edit9, num2str(handles.sv));
else
    disp('#Layer number outside dataset range');
    handles.setstr(handles.listbox2, cmdwinout());
    handles.sv = 1; handles.n = 1; handles.v = 0;
end
    
% Display voxel data
handles.setstr(handles.edit9, num2str(handles.sv));
handles.setstr(handles.edit1, num2str(handles.realamp{handles.n}(handles.v+1,1)));
handles.setstr(handles.edit2, num2str(handles.realamp{handles.n}(handles.v+1,2)));
handles.setstr(handles.edit3, num2str(handles.realamp{handles.n}(handles.v+1,3)));
handles.setstr(handles.edit4, num2str(handles.realamp{handles.n}(handles.v+1,4)));
handles.setstr(handles.edit5, num2str(handles.realamp{handles.n}(handles.v+1,5)));
handles.setstr(handles.edit6, num2str(handles.realamp{handles.n}(handles.v+1,6)));
handles.setstr(handles.edit7, num2str(handles.realamp{handles.n}(handles.v+1,7)));
handles.setstr(handles.edit8, num2str(handles.realamp{handles.n}(handles.v+1,8)));


% Update handles structure
guidata(hObject, handles);
    
function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double

% Check if file is open
if handles.num == 0
    return;
end

% Get jMRUI voxel #
handles.n = str2double(handles.getstr(handles.edit10));
handles.v = str2double(handles.getstr(handles.edit11));
if (handles.v >= 0 && handles.v <= 255 && ~isnan(handles.v))
    handles.sv = jmrui2siemens(handles.n, handles.v);
    handles.setstr(handles.edit9, num2str(handles.sv));
else
    disp('#Voxel number outside dataset range');
    handles.setstr(handles.listbox2, cmdwinout());
    handles.sv = 1; handles.n = 1; handles.v = 0;
end

% Display voxel data
handles.setstr(handles.edit9, num2str(handles.sv));
handles.setstr(handles.edit1, num2str(handles.realamp{handles.n}(handles.v+1,1)));
handles.setstr(handles.edit2, num2str(handles.realamp{handles.n}(handles.v+1,2)));
handles.setstr(handles.edit3, num2str(handles.realamp{handles.n}(handles.v+1,3)));
handles.setstr(handles.edit4, num2str(handles.realamp{handles.n}(handles.v+1,4)));
handles.setstr(handles.edit5, num2str(handles.realamp{handles.n}(handles.v+1,5)));
handles.setstr(handles.edit6, num2str(handles.realamp{handles.n}(handles.v+1,6)));
handles.setstr(handles.edit7, num2str(handles.realamp{handles.n}(handles.v+1,7)));
handles.setstr(handles.edit8, num2str(handles.realamp{handles.n}(handles.v+1,8)));

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check if file is open
if handles.num == 0
    return;
end

% Find toggled button states
if (handles.getval(handles.radiobutton1)) == 1
    handles.realamp = handles.freq;
elseif (handles.getval(handles.radiobutton2)) == 1
    handles.realamp = handles.freqsd;
elseif (handles.getval(handles.radiobutton3)) == 1
    handles.realamp = handles.amp;
elseif (handles.getval(handles.radiobutton4)) == 1
    handles.realamp = handles.ampsd;
elseif (handles.getval(handles.radiobutton6)) == 1
    for i=1:handles.num
        handles.realamp{i} = handles.amp{i}./handles.damp{i};
    end
elseif (handles.getval(handles.radiobutton7)) == 1
    for i=1:handles.num
        handles.realamp{i} = handles.ampsd{i}./handles.damp{i};
    end
elseif (handles.getval(handles.radiobutton8)) == 1
    amplitude = cell(1,handles.num);
    for i=1:handles.num
        amplitude{i} = handles.amp{i}./handles.damp{i};
    end
    % Normalize by (1 - PCR, 2 - GAMMA-ATP, etc.)
    switch(handles.getval(handles.popupmenu3))
        case 1
            for i=1:handles.num
                handles.realamp{i} =...
                    amplitude{i}./repmat(amplitude{i}(:,1),1,8);
            end
        case 2
            for i=1:handles.num
                handles.realamp{i} =...
                    amplitude{i}./repmat(amplitude{i}(:,2),1,8);
            end
        case 3
            for i=1:handles.num
                handles.realamp{i} =...
                    amplitude{i}./repmat(amplitude{i}(:,3),1,8);
            end
        case 4
            for i=1:handles.num
                handles.realamp{i} =...
                    amplitude{i}./repmat(amplitude{i}(:,4),1,8);
            end
        case 5
            for i=1:handles.num
                handles.realamp{i} =...
                    amplitude{i}./repmat(amplitude{i}(:,5),1,8);
            end
        case 6
            for i=1:handles.num
                handles.realamp{i} =...
                    amplitude{i}./repmat(amplitude{i}(:,6),1,8);
            end
        case 7
            for i=1:handles.num
                handles.realamp{i} =...
                    amplitude{i}./repmat(amplitude{i}(:,7),1,8);
            end
        case 8
            for i=1:handles.num
                handles.realamp{i} =...
                    amplitude{i}./repmat(amplitude{i}(:,8),1,8);
            end
    end
elseif (handles.getval(handles.radiobutton9)) == 1
    handles.realamp = handles.damp;
elseif (handles.getval(handles.radiobutton10)) == 1
    handles.realamp = handles.damp;
else
    % Display in Command Window
    disp('#Select Result Option.');
    handles.setstr(handles.listbox2, cmdwinout());
end

% Display Results
if ~isempty(handles.realamp)
    handles.setstr(handles.edit1, num2str(handles.realamp{handles.n}(handles.v+1,1)));
    handles.setstr(handles.edit2, num2str(handles.realamp{handles.n}(handles.v+1,2)));
    handles.setstr(handles.edit3, num2str(handles.realamp{handles.n}(handles.v+1,3)));
    handles.setstr(handles.edit4, num2str(handles.realamp{handles.n}(handles.v+1,4)));
    handles.setstr(handles.edit5, num2str(handles.realamp{handles.n}(handles.v+1,5)));
    handles.setstr(handles.edit6, num2str(handles.realamp{handles.n}(handles.v+1,6)));
    handles.setstr(handles.edit7, num2str(handles.realamp{handles.n}(handles.v+1,7)));
    handles.setstr(handles.edit8, num2str(handles.realamp{handles.n}(handles.v+1,8)));
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check if handles.voxellist is empty
if isempty(handles.voxellist)
    return;
end

% Get save directory
[savename,pathname,fi] = uiputfile({'*.csv';},'Save File');

if fi == 0
    % NO save directory chosen
    disp('#No Directory Chosen');
    handles.setstr(handles.listbox2, cmdwinout());
    return;
end

% Store voxel values in voxelvalue
voxelvalue = zeros(length(handles.voxellist),8);

for i=1:length(handles.voxellist)
     [n,v] = siemens2jmrui(str2double(handles.voxellist{i}));
     voxelvalue(i,1:8) = handles.realamp{n}(v+1,1:8);
end

% Make table to write to CSV file
table = [{'Voxel #'} {'PCR'} {'GAMMA-ATP'} {'ALPHA-ATP'} {'PE'} {'PC'}...
    {'GPE'} {'GPC'} {'PI 1'}; handles.voxellist num2cell(voxelvalue)];

% Write to CSV file
writetable2csv(table, pathname, savename);

% Display Sucessful Save
disp('#CSV Write Successful');
handles.setstr(handles.listbox2, cmdwinout());

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check if handles.num is 0
if handles.num == 0
    return;
end

% Check if handles.sv is NaN
if isnan(handles.sv)
    return;
end

% Save voxel number
if isempty(handles.voxellist)
    handles.voxellist = {num2str(handles.sv)};
else
    handles.voxellist = [{num2str(handles.sv)}; handles.voxellist];
end
% Set selection to current voxel
handles.setval(handles.listbox3, 1);
% Display saved voxels
handles.setstr(handles.listbox3, handles.voxellist);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check if handles.voxellist is empty
if isempty(handles.voxellist)
    return;
end

% Delete selected voxel
selected = handles.getval(handles.listbox3);
handles.voxellist{selected} = '';
handles.voxellist(strcmp('',handles.voxellist)) = [];

% Display saved voxels
if selected == 1
    handles.setval(handles.listbox3, 1);
else
    handles.setval(handles.listbox3, selected-1);
end
handles.setstr(handles.listbox3, handles.voxellist);

% Update handles structure
guidata(hObject, handles);

% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3

% Check if handles.voxellist is empty
if isempty(handles.voxellist)
    return;
end

% Get selected voxel
selected = handles.getval(handles.listbox3);
handles.sv = str2double(handles.voxellist{selected});
[handles.n, handles.v] = siemens2jmrui(handles.sv);
handles.setstr(handles.edit10, num2str(handles.n));
handles.setstr(handles.edit11, num2str(handles.v));

% Display voxel data
handles.setstr(handles.edit9, num2str(handles.sv));
handles.setstr(handles.edit10, num2str(handles.n));
handles.setstr(handles.edit11, num2str(handles.v));
handles.setstr(handles.edit1, num2str(handles.realamp{handles.n}(handles.v+1,1)));
handles.setstr(handles.edit2, num2str(handles.realamp{handles.n}(handles.v+1,2)));
handles.setstr(handles.edit3, num2str(handles.realamp{handles.n}(handles.v+1,3)));
handles.setstr(handles.edit4, num2str(handles.realamp{handles.n}(handles.v+1,4)));
handles.setstr(handles.edit5, num2str(handles.realamp{handles.n}(handles.v+1,5)));
handles.setstr(handles.edit6, num2str(handles.realamp{handles.n}(handles.v+1,6)));
handles.setstr(handles.edit7, num2str(handles.realamp{handles.n}(handles.v+1,7)));
handles.setstr(handles.edit8, num2str(handles.realamp{handles.n}(handles.v+1,8)));

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
handles.setval(handles.radiobutton1,1);
handles.setval(handles.radiobutton2,0);
handles.setval(handles.radiobutton3,0);
handles.setval(handles.radiobutton4,0);
handles.setval(handles.radiobutton6,0);
handles.setval(handles.radiobutton7,0);
handles.setval(handles.radiobutton8,0);
handles.setval(handles.radiobutton9,0);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
handles.setval(handles.radiobutton1,0);
handles.setval(handles.radiobutton2,1);
handles.setval(handles.radiobutton3,0);
handles.setval(handles.radiobutton4,0);
handles.setval(handles.radiobutton6,0);
handles.setval(handles.radiobutton7,0);
handles.setval(handles.radiobutton8,0);
handles.setval(handles.radiobutton9,0);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
handles.setval(handles.radiobutton1,0);
handles.setval(handles.radiobutton2,0);
handles.setval(handles.radiobutton3,1);
handles.setval(handles.radiobutton4,0);
handles.setval(handles.radiobutton6,0);
handles.setval(handles.radiobutton7,0);
handles.setval(handles.radiobutton8,0);
handles.setval(handles.radiobutton9,0);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
handles.setval(handles.radiobutton1,0);
handles.setval(handles.radiobutton2,0);
handles.setval(handles.radiobutton3,0);
handles.setval(handles.radiobutton4,1);
handles.setval(handles.radiobutton6,0);
handles.setval(handles.radiobutton7,0);
handles.setval(handles.radiobutton8,0);
handles.setval(handles.radiobutton9,0);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
handles.setval(handles.radiobutton1,0);
handles.setval(handles.radiobutton2,0);
handles.setval(handles.radiobutton3,0);
handles.setval(handles.radiobutton4,0);
handles.setval(handles.radiobutton6,1);
handles.setval(handles.radiobutton7,0);
handles.setval(handles.radiobutton8,0);
handles.setval(handles.radiobutton9,0);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7
handles.setval(handles.radiobutton1,0);
handles.setval(handles.radiobutton2,0);
handles.setval(handles.radiobutton3,0);
handles.setval(handles.radiobutton4,0);
handles.setval(handles.radiobutton6,0);
handles.setval(handles.radiobutton7,1);
handles.setval(handles.radiobutton8,0);
handles.setval(handles.radiobutton9,0);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8
handles.setval(handles.radiobutton1,0);
handles.setval(handles.radiobutton2,0);
handles.setval(handles.radiobutton3,0);
handles.setval(handles.radiobutton4,0);
handles.setval(handles.radiobutton6,0);
handles.setval(handles.radiobutton7,0);
handles.setval(handles.radiobutton8,1);
handles.setval(handles.radiobutton9,0);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9
handles.setval(handles.radiobutton1,0);
handles.setval(handles.radiobutton2,0);
handles.setval(handles.radiobutton3,0);
handles.setval(handles.radiobutton4,0);
handles.setval(handles.radiobutton6,0);
handles.setval(handles.radiobutton7,0);
handles.setval(handles.radiobutton8,0);
handles.setval(handles.radiobutton9,1);

% Update handles structure
guidata(hObject, handles);

%-------------------------------NOT USED----------------------------------%


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double

function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double

function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double

% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
