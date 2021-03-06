function varargout = Preprocess(varargin)

% PREPROCESS MATLAB code for Preprocess.fig
%      PREPROCESS, by itself, creates a new PREPROCESS or raises the existing
%      singleton*.
%
%      H = PREPROCESS returns the handle to a new PREPROCESS or the handle to
%      the existing singleton*.
%
%      PREPROCESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREPROCESS.M with the given input arguments.
%
%      PREPROCESS('Property','Value',...) creates a new PREPROCESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Preprocess_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Preprocess_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Preprocess

% Last Modified by GUIDE v2.5 20-Nov-2014 14:55:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Preprocess_OpeningFcn, ...
                   'gui_OutputFcn',  @Preprocess_OutputFcn, ...
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


% --- Executes just before Preprocess is made visible.
function Preprocess_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Preprocess (see VARARGIN)
%%Defaults

[~,pth]=unix('which qsub');
setenv('SGE_ROOT', regexprep(pth,'/bin.*',''));
[file,path] = uigetfile({'*.mat'},'Select a list of subject directories');
a=[path,file];
load(a)
%[file,path] = uigetfile({'*.mat'},'Select default params file');
%b=[path,file];



 guihome=fileparts(which('Preprocess'));
 defaultsfile=[guihome,'/PreprocDefaults.mat'];
 load(defaultsfile)
handles.subjdir=subjdir;
handles.subsfound=length(handles.subjdir);
set(handles.dirfound,'String',handles.subsfound)
optnames=fieldnames(opt);
for x=1:length(optnames)
if opt.(optnames{x})==1
optString.(optnames{x})='Enabled';
elseif opt.(optnames{x})==0
    optString.(optnames{x})='Disabled';
else
    optString.(optnames{x})=opt.(optnames{x});
end
end


    optString.RegType='SPM';

if strcmp(optString.fsl_ReSt,'Enabled')
    optString.ReStType='FSL';
else
    optString.ReStType='SPM';
end
optString.smooth='SPM';
optStringdata={optString.tr,optString.trnum,optString.delscans,optString.scanner,optString.rsprefix,optString.t1prefix,optString.sliceorder,optString.ReStType,optString.ReStType,optString.RegType,optString.RegType,optString.smooth,optString.filter,optString.mfilter,optString.highFreq,optString.lowFreq,optString.ileavecutoff,optString.ileave,optString.mspikecutoff,optString.mspike,optString.IcaFull};
textBlock=sprintf(['SCANNER PARAMETERS-',...
    '\n---TR: %s',...
    '\n---Number of TRs: %s',...
    '\n---Delete TRs at Beginning: %s',...
    '\n---Scanner Name: %s',...
    '\n---rsfMRI Images Prefix: %s',...
    '\n---Structural Image Prefix: %s',...
    '\n---Slice Order: %s',...
    '\n\nBASIC PREPROCESSING STEPS-',...
    '\n---Slice Timing Correction: %s',...
    '\n---Realignment: %s',...
    '\n---Coregistration: %s',...
    '\n---Normalization: %s',...
    '\n---Smoothing: %s',...
    '\n---Bandpass Filtering-',...
    '\n------Filter Smoothed Images: %s',...
    '\n------Filter Motion Parameters: %s',...
    '\n------High Pass Threshold: %sHz',...
    '\n------Low Pass Threshold: %sHz',...
    '\n\nADVANCED PREPROCESSING STEPS-',...
    '\n---Interleave Correction (cutoff: %sz): %s',...
    '\n---Motion QA Report (cutoff: %smm): %s',...
    '\n---Full ICA Report: %s'], optStringdata{:});
set(handles.batchpar,'Value',1)
handles.batchpar='batchparOn';

set(handles.text6,'String',textBlock)


%Output dir
Outstring={};


%Output dir
Outstring={};
Outstring='RTCNn';
Outstring=[Outstring,'S'];
if opt.filter
    Outstring=[Outstring,'F'];
end
if opt.mfilter
    Outstring=[Outstring,'m'];
end
if opt.ileave
    Outstring=[Outstring,'D'];
end
if opt.IcaFull
    Outstring=[Outstring,'I'];
end


set(handles.OutDir,'String',['Output Suffix: ',Outstring]);
opt.outstring=Outstring;
handles.opt=opt;

% Choose default command line output for Preprocess
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Preprocess wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Preprocess_OutputFcn(hObject, eventdata, handles)
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
if  strcmp(get(handles.ready,'String'),'SCAN')
    OKmessage({'Scan directories first!'})
else
    preproc_root=fileparts(fileparts(which('Preprocess.m')));
    handles.opt.preproc_root=preproc_root;
    for x=1:length(handles.subjdir)
        subjlist=handles.subs{x};
        subjlist.opt=handles.opt;
        Outstring=handles.opt.outstring;
        outdir=[handles.subjdir{x,1},'/interfmri_',Outstring,'/log/'];
        outdirRoot=[handles.subjdir{x,1},'/interfmri_',Outstring];
        if exist(outdir)
            unix(['rm -r ',outdirRoot]);
            cmd=['mkdir -p ', outdir];
            unix(cmd)
            save([outdir,'preprocSetup.mat'],'subjlist');
        elseif ~exist(outdir)
            cmd=['mkdir -p ', outdir];
            unix(cmd)
            save([outdir,'preprocSetup.mat'],'subjlist');
        end
        try
            if strcmp(handles.opt.process,'batchser')
                unix(['sed "s|loadsubfile|',outdir,'preprocSetup.mat|g" ',preproc_root,'/proc/rsfmri_preprocess_MASTER.m  > ',outdir,'rsfmri_preprocess.m'])
                display(['Running ',outdir,'rsfmri_preprocess.m'])
                run([outdir,'rsfmri_preprocess.m'])
            end
        catch Err
            save([outdir,'PreprocError.mat'],'Err')
            display([handles.subjdir{x,1},' failed! Error log saved to:' outdir])
        end
    end

    if strcmp(handles.opt.process,'batchpar')
        fid=fopen([preproc_root,'/proc/subjdir.txt'],'w+','n', 'US-ASCII');
        fprintf(fid,'%s\n%s\n',handles.opt.outstring, handles.subjdir{:});
        fclose(fid);
        unix([preproc_root,'/grid/RunSGEpreproc_MASTER_GUI ',preproc_root])
        display('Jobs sent to SGE')
    end
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helptext=sprintf(['\n 1) CHECK PARAMETERS: \n\nReview default parameters listed under "Pipeline Specifications" if your basic parameters differ or you would like to run a diferent configuration, click on "View & Edit Default Parameters"',...
'\n\n 2) SCAN DIRECTORIES: \n\nWhen the "Pipeline Specifications" panel displays your desired configuration hit the "Scan Subject Directories" button. This will go into each of your subjects directories and will determine if the'...
' correct number of functional and structural files exist, corresponding to the user defined number of TRs and rsfMRI/Structural image prefixes. \n\nAfter scanning completes, if the number listed under "Subjects ready to preprocess" does'...
' not match your number of subjects, check the failed subject listings by clicking the buttons next to each fail category and check the listed subject\''s directories to make sure they have the correct number of scans and the correct file prefixes.'...
'\n\n 3) RUN: \n\nWhen the "Subjects ready to preprocess" count matches the count of your subject list, the last step before hitting run is to specify the processing type: \n\n---Parallel Processing- requires Sun Grid Engine to be installed, ',...
'configured and "qsub" must be on the path. Matlab will pass to whatever queues are available to qsub. Each subject will be run on its own display-free instance of matlab in the background. Logs are saved to the subjects log'...
' directory in interfmri_<output suffix> as text files that begin with e (errors) and o(stdout). \n\n ---Serial Processing- Runs all subjects within the current matlab session, one at a time. If a subject in the list fails, the next subject will begin processing',...
'and an error log will be saved to the failed subject\''s  interfmri_<output suffix>/log directory and called PreprocError.mat \n\nHit Run and refer to the command window in matlab for progress on job submission to SGE (if parallel) or progress on running each subject (if serial)']);
helpfig=helpDocs({helptext});



% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function newsublist_Callback(hObject, eventdata, handles)
% hObject    handle to newsublist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile({'*.mat'},'Select a list of subject directories');
a=[path,file];
load(a)
handles.subjdir=subjdir;
handles.subsfound=length(handles.subjdir);
set(handles.dirfound,'String',handles.subsfound)
set(handles.pthfound,'String','SCAN')
set(handles.rawfmri,'String','SCAN')
set(handles.T1,'String','SCAN')
set(handles.ready,'String','SCAN')

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newsubjdir=ViewDirList(handles);
handles.subjdir=newsubjdir;

handles.subsfound=length(handles.subjdir);
%%Add subexist to global path
[~,goodsubs,badsubs,bsubind]=evalc('subexist(handles.subjdir)');
if isempty(badsubs)
    handles.pathconfirm=0;
else
    handles.pathconfirm=length(badsubs);
    handles.bsubpath=badsubs; 
end
set(handles.dirfound,'String',handles.subsfound)
set(handles.pthfound,'String',handles.pathconfirm)

handles.bsubind=bsubind;
 set(handles.rawfmri,'String','SCAN')
 set(handles.T1,'String','SCAN')
set(handles.ready,'String','SCAN')

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
optOrig=handles.opt;

newProc=PreprocAdvanced;
if ~isempty(newProc)
    opt=newProc;
    optnames=fieldnames(opt);
    for x=1:length(optnames)
        if opt.(optnames{x})==1
            optString.(optnames{x})='Enabled';
        elseif opt.(optnames{x})==0
            optString.(optnames{x})='Disabled';
        else
            optString.(optnames{x})=opt.(optnames{x});
        end
    end




    if strcmp(optString.fsl_ReSt,'Enabled')
        optString.ReStType='FSL';
    else
        optString.ReStType='SPM';
    end
    optString.RegType='SPM';
    optString.smooth='SPM';
    optStringdata={optString.tr,optString.trnum,optString.delscans,optString.scanner,optString.rsprefix,optString.t1prefix,optString.sliceorder,optString.ReStType,optString.ReStType,optString.RegType,optString.RegType,optString.smooth,optString.filter,optString.mfilter,optString.highFreq,optString.lowFreq,optString.ileavecutoff,optString.ileave,optString.mspikecutoff,optString.mspike,optString.IcaFull};
    textBlock=sprintf(['SCANNER PARAMETERS-',...
        '\n---TR: %s',...
        '\n---Number of TRs: %s',...
        '\n---Delete TRs at Beginning: %s',...
        '\n---Scanner Name: %s',...
        '\n---rsfMRI Images Prefix: %s',...
        '\n---Structural Image Prefix: %s',...
        '\n---Slice Order: %s',...
        '\n\nBASIC PREPROCESSING STEPS-',...
        '\n---Slice Timing Correction: %s',...
        '\n---Realignment: %s',...
        '\n---Coregistration: %s',...
        '\n---Normalization: %s',...
        '\n---Smoothing: %s',...
        '\n---Bandpass Filtering-',...
        '\n------Filter Smoothed Images: %s',...
        '\n------Filter Motion Parameters: %s',...
        '\n------High Pass Threshold: %sHz',...
        '\n------Low Pass Threshold: %sHz',...
        '\n\nADVANCED PREPROCESSING STEPS-',...
        '\n---Interleave Correction (cutoff: %sz): %s',...
        '\n---Motion QA Report (cutoff: %smm): %s',...
        '\n---Full ICA Report: %s'], optStringdata{:});

    set(handles.text6,'String',textBlock)


    %Output dir
    Outstring={};
    Outstring='RTCNn';
    Outstring=[Outstring,'S'];
    if opt.filter
        Outstring=[Outstring,'F'];
    end
    if opt.mfilter
        Outstring=[Outstring,'m'];
    end
    if opt.ileave
        Outstring=[Outstring,'D'];
    end
    if opt.IcaFull
        Outstring=[Outstring,'I'];
    end
    opt.outstring=Outstring;

    set(handles.OutDir,'String',['Output Suffix: ',Outstring]);
    if ~strcmp(optOrig.trnum,opt.trnum) || ~strcmp(optOrig.delscans,opt.delscans) || ~strcmp(optOrig.t1prefix,opt.t1prefix) || ~strcmp(optOrig.rsprefix,opt.rsprefix)
        set(handles.pthfound,'String','SCAN')
        set(handles.rawfmri,'String','SCAN')
        set(handles.T1,'String','SCAN')
        set(handles.ready,'String','SCAN')
    end

    handles.opt=opt;
    handles.opt.process=optOrig.process;
end
% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close


% --- Executes when selected object is changed in uipanel9.
function uipanel9_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel9
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.opt.process=get(hObject,'Tag');
% Update handles structure
guidata(hObject, handles);


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in fpath.
function fpath_Callback(hObject, eventdata, handles)
% hObject    handle to fpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ViewDirListBsubs(handles.bsubpath);


% --- Executes on button press in ffmri.
function ffmri_Callback(hObject, eventdata, handles)
% hObject    handle to ffmri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ViewDirListBsubs(handles.bsubsfMRI);


% --- Executes on button press in fT1.
function fT1_Callback(hObject, eventdata, handles)
% hObject    handle to fT1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ViewDirListBsubs(handles.bsubsT1);


% --- Executes on button press in scan.
function scan_Callback(hObject, eventdata, handles)
% hObject    handle to scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fignum=PopUpMessage('Please wait while the subject directories are scanned...');
display('Scanning directories.....')


[~,goodsubs,badsubs,bsubind]=evalc('subexist(handles.subjdir)');
close(fignum)
if isempty(badsubs)
    handles.pathconfirm=0;
    handles.bsubpath={};
else
    handles.pathconfirm=length(badsubs);
    handles.subjdir=goodsubs;
    handles.bsubpath=badsubs;
end

set(handles.pthfound,'String',handles.pathconfirm)

handles.bsubind=bsubind;

[handles.bsubsT1,handles.bsubsfMRI,subs]=GetSubjectImgs(handles.subjdir,str2num(handles.opt.trnum),str2num(handles.opt.delscans),handles.opt.rsprefix,handles.opt.t1prefix,'rsfmri');
handles.subs=subs;
set(handles.T1,'String',length(handles.bsubsT1));
set(handles.rawfmri,'String',length(handles.bsubsfMRI));
set(handles.ready,'String',length(handles.subjdir)-length(handles.bsubsT1)-length(handles.bsubsfMRI));
% Update handles structure
guidata(hObject, handles);
                                                                                                                                                                                                                                                                                                                                                                                                                                                          