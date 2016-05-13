function varargout = teaching_app1_6(varargin)
% TEACHING_APP1_5 MATLAB code for teaching_app1_5.fig
%      TEACHING_APP1_5, by itself, creates a new TEACHING_APP1_5 or raises the existing
%      singleton*.
%
%      H = TEACHING_APP1_5 returns the handle to a new TEACHING_APP1_5 or the handle to
%      the existing singleton*.
%
%      TEACHING_APP1_5('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEACHING_APP1_5.M with the given input arguments.
%
%      TEACHING_APP1_5('Property','Value',...) creates a new TEACHING_APP1_5 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before teaching_app1_5_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to teaching_app1_5_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help teaching_app1_5

% Last Modified by GUIDE v2.5 15-Dec-2015 16:08:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @teaching_app1_5_OpeningFcn, ...
    'gui_OutputFcn',  @teaching_app1_5_OutputFcn, ...
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


%%plot3(a(1), a(2), a(3), 'r.', 'Parent', FirstAxesHandle)

% --- Executes just before teaching_app1_5 is made visible.
function teaching_app1_5_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure ith handles and user data (see GUIDATA)
% varargin   command line arguments to teaching_app1_5 (see VARARGIN)

% Choose default command line output for teaching_app1_5
handles.output = hObject;
clc

load('Data.mat');       %Load in the sample Epochs, Channel locations, sample rate etc.
ss=get(0,'screensize');
w=ss(3);    %Screen width
h=ss(4);     %Screen height
p=get(handles.figure1,'Position');
width=p(3);     %GUI width and height
height=p(4);

set(handles.figure1,'Position',[w*1/8,h*2/16,width,height]);

handles.tcdlogo=imread('trinity-stacked.png');    
%handles.tcdlogo=flipud(handles.tcdlogo);
axes(handles.logo)
image(handles.tcdlogo);
set(gca,'XTick',[],'YTick',[]);
box off
set(gca,'XColor',[1 1 1],'YColor',[1 1 1],'TickDir','out')

%Set handles
handles.ChannelLabels=ChannelLabels;
handles.fs=SampleRate;
handles.EEGlocs=EEGlocs;
handles.p2pvalues=values;
handles.ERP=EEG;
handles.Reference_ERP_applied=0;
handles.Reference_ERP_filt=0;
handles.Reference_ERP=0;
handles.c=[];
handles.current_channel=1;
handles.reference=0;
handles.trig1=1;
handles.trig2=0;
handles.topocheck=0;
handles.TemporalERP=zeros(1,601);
handles.window=0;
handles.cut_off=99;
handles.chan_indices= [19 17 16 18 20; 9 7 6 8 10; 4 2 1 3 5; 14 12 11 13 15; 24 22 21 23 25];

%Plotting the Topographic Map
bheadsymbolplot
handles.cl=ChannelCoordinates.*250;
t=text(handles.cl(:,1),handles.cl(:,2), ChannelLabels,'Parent',handles.Spatial,'FontSize',12,'FontName','Source Sans Pro');
set(t(1),'Color',[0.055 0.451 0.7255],'FontSize',17,'FontWeight','bold','FontName','Source Sans Pro');
handles.t=t;
set(handles.apply_reference,'Enable','off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes teaching_app1_5 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = teaching_app1_5_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in stimulus.
function stimulus_Callback(hObject, eventdata, handles)
% hObject    handle to stimulus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(handles.selection_check,'Visible','off');       %'No ERPs Selected' is automatically reset. This will change if radio buttons are selected
i=get(handles.Channel_list,'Value');        %Determine which channel is being used

%Will only excute this plotting function if a new channel has been selected
if handles.trig1
    
    if (get(handles.checkbox1,'Value')==1)
        
        plot_EEG(squeeze(handles.ERP(i,:,:)),handles.ChannelLabels(i));     %Pop up window animating the plotting of EEG
        
    end
    
    for j=1:28

        a=eval(['handles.erp' int2str(j)]);        %Determine the current axis
        axes(a);
        plot(1:601,squeeze(handles.ERP(i,j,:)),'Color',[0.055 0.451 0.7255])     %Plot ERP
        set(gca,'XTick',[],'YTick',[]);
        ylim([-50 50])
        xlim([-50 651])
        
        if (j==7 && (get(handles.checkbox1,'Value')==1))
            
            pause(1)
            
        end
        
        if j>=22
            set(gca,'XTick',[],'YTick',[],'FontUnit','normalized');
            %set(gca,'XTickLabel',{-0.5 0 1 2});
            
        end
    end
    
    handles.trig1=0;
    guidata(hObject,handles);
    
end

%Plot the topographic map

if ~handles.topocheck
    
    extra=[ 0 75; 0 -75];
    CC=[handles.cl;extra];
    handles.p2pvalues=[handles.p2pvalues; ones(2,1)*mean(handles.p2pvalues)];
    
    axes(handles.Spatial);
    btopoplot(handles.p2pvalues',CC(:,1)',CC(:,2)',[min(handles.p2pvalues)-4 max(handles.p2pvalues)])    
    handles.topocheck=1;
    
end



%Function that averages epochs of all selected rows. Returns a PxQ matrix
%where P is the number of selected rows (between 0 and 4) and are the
%sampled points of the averaged EPOCH for each row
[handles.TemporalERP,f]=averaging_erps(handles.ERP(i,:,:),handles);

if isempty(f)
    %Case 1: No epoch rows are selected. Turn on the 'No ERPs Selected
    %Text'
    set(handles.selection_check,'Visible','on');
    set(handles.baseline_slider,'Enable','off');
    set(handles.lowPass_slider,'Enable','off');
    cla(handles.temporal)
    
else if length(f)==1
        %Case 2: Only one Epoch row is selected. Therefore there is no need to do anymore averaging
    else
        %Case 3: More thatn one epoch row. Find the average of these rows
        handles.TemporalERP=mean(handles.TemporalERP);
        
    end
    
    %Filtering of the data based on the cut off frequency of the low pass
    %filter slider.   
    plotting1(hObject,handles);    
    set(handles.baseline_slider,'Enable','on');     %Allow user to change slider values
    set(handles.lowPass_slider,'Enable','on');
    
end


guidata(hObject,handles);





% --- Executes on selection change in Channel_list.
function Channel_list_Callback(hObject, eventdata, handles)
% hObject    handle to Channel_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Channel_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Channel_list

handles.trig1=1;
guidata(hObject,handles);
chan_ref_pop_Callback(hObject, eventdata, handles)
stimulus_Callback(hObject, eventdata, handles)
handles.trig1=0;

guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function Channel_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Channel_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on slider movement.
function lowPass_slider_Callback(hObject, eventdata, handles)
% hObject    handle to lowPass_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
set(handles.lowPass_slider,'Enable','off')
handles.cut_off=get(handles.lowPass_slider,'Value')*100;
guidata(hObject,handles);

[hObject, handles]=reference_plotting1(hObject,handles);            %Filter signal of the references
plotting1(hObject, handles);
set(handles.Cut_off_freq,'String',[int2str(handles.cut_off) 'Hz']); %Update display

[b,a]=butter(5,handles.cut_off/(handles.fs/2),'low');

%Plot the frequency response of the filter
axes(handles.show_filter);
cla;
[h,w]=freqz(b,a);
plot(w/pi*handles.fs/2,abs(h),'LineWidth',3);

hold on;
xlabel('Frequency (Hz)','FontName','Source Sans Pro');
set(gca,'XColor',[1 1 1],'YColor',[1 1 1]);
xlim([0 120]);
ylim([0 1.2]);
plot([handles.cut_off handles.cut_off], [0 1.2], 'r--','LineWidth',2);
text(handles.cut_off+5,1,'f_{cut off}','Color','red','FontSize',12,'FontName','Source Sans Pro');
drawnow;
hold off;

set(handles.lowPass_slider,'Enable','on')





% --- Executes on slider movement.
function baseline_slider_Callback(hObject, eventdata, handles)
% hObject    handle to baseline_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

set(handles.baseline_slider,'Enable','off');
handles.window=(1-get(handles.baseline_slider,'Value'))*100;    %Get time window value
guidata(hObject,handles);

[hObject, handles]=reference_plotting1(hObject,handles);

plotting1(hObject,handles);

set(handles.window_length,'String',[num2str(handles.window/100) 's']);
set(handles.baseline_slider,'Enable','on');

guidata(hObject,handles);






% --- Executes on selection change in chan_ref_pop.
function chan_ref_pop_Callback(hObject, eventdata, handles)
% hObject    handle to chan_ref_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chan_ref_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chan_ref_pop

%%---------------------------------------------------------------------%%
%This function does 2 things.
%1. Display: It updates the display on the topographic map
%2. It finds the average ERP from surrounding reference channel
handles.Reference_ERP_filt=0;
cla(handles.reference_plot);
set(handles.apply_reference,'Enable','off');
handles.technique=get(handles.chan_ref_pop, 'Value');       %Checks the channel referencing technique that should be used
set(handles.selection_check2,'Visible','off');          %Automatically resets the 'No ERPs Selected Button' to off
k=get(handles.Channel_list,'Value');                    %Find the current channel (Display purposes)
axes(handles.Spatial);                                  %Reset all the channel texts to black and the selected channel to blue
set(handles.t,'Color','black','FontSize',12,'FontWeight','normal','FontName','Source Sans Pro');
set(handles.t(k),'Color',[0.055 0.451 0.7255],'FontSize',17,'FontWeight','bold','FontName','Source Sans Pro');

%Update the current_channel handle
handles.current_channel=k;
guidata(hObject,handles);
handles.c=[];

if (any(handles.window) && any(handles.TemporalERP))
    handles.reference=mean(handles.TemporalERP((101-handles.window):101));
else
    handles.reference=0;
end
set(handles.baseline_value,'String',[num2str(handles.reference)]);

if handles.technique>1
    
    set(handles.apply_reference,'Enable','on');
    
    [y,x]=find(handles.chan_indices==handles.current_channel);
    
    
    
    if handles.technique==2
        %get the vertical Laplacian coordinates
        axes(handles.Spatial);
        
        if x>1
            set(handles.t(handles.chan_indices(y,x-1)),'Color',[0.094 0.663 0.184],'FontSize',14,'FontWeight','bold');
            handles.c(end+1)=handles.chan_indices(y,x-1);               %c=reference channels to average
        end
        
        if x<5
            set(handles.t(handles.chan_indices(y,x+1)),'Color',[0.094 0.663 0.184],'FontSize',14,'FontWeight','bold');
            handles.c(end+1)=handles.chan_indices(y,x+1);
        end
        
        if y>1
            set(handles.t(handles.chan_indices(y-1,x)),'Color',[0.094 0.663 0.184],'FontSize',14,'FontWeight','bold');
            handles.c(end+1)=handles.chan_indices(y-1,x);
        end
        
        if y<5
            set(handles.t(handles.chan_indices(y+1,x)),'Color',[0.094 0.663 0.184],'FontSize',14,'FontWeight','bold');
            handles.c(end+1)=handles.chan_indices(y+1,x);
        end
    end
    
    if handles.technique==3
        
        set(handles.t,'Color',[0.094 0.663 0.184],'FontSize',14,'FontWeight','bold');
        set(handles.t(handles.current_channel),'Color',[0.055 0.451 0.7255],'FontSize',17,'FontWeight','bold');
        handles.c=1:25;
        handles.c(handles.current_channel)=[];
        
    end
    
else
    
    plotting1(hObject,handles);
    
end

if ~isempty(handles.c)
        
    [hObject, handles]=reference_plotting1( hObject, handles);
    
end

guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function chan_ref_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chan_ref_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in apply_reference.
function apply_reference_Callback(hObject, eventdata, handles)
% hObject    handle to apply_reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.apply_reference,'Enable','off');
guidata(hObject,handles);
plotting1(hObject,handles);



% --- Executes during object creation, after setting all properties.
function baseline_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baseline_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function lowPass_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowPass_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in erp_radio_1to7.
function erp_radio_1to7_Callback(hObject, eventdata, handles)
% hObject    handle to erp_radio_1to7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of erp_radio_1to7
set(handles.selection_check,'Visible','off');

% --- Executes on button press in erp_radio_8to14.
function erp_radio_8to14_Callback(hObject, eventdata, handles)
% hObject    handle to erp_radio_8to14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of erp_radio_8to14
set(handles.selection_check,'Visible','off');


% --- Executes on button press in erp_radio_15to21.
function erp_radio_15to21_Callback(hObject, eventdata, handles)
% hObject    handle to erp_radio_15to21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of erp_radio_15to21
set(handles.selection_check,'Visible','off');


% --- Executes on button press in erp_radio_22to28.
function erp_radio_22to28_Callback(hObject, eventdata, handles)
% hObject    handle to erp_radio_22to28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of erp_radio_22to28
set(handles.selection_check,'Visible','off');


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
