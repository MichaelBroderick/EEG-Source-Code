function  plotting1( hObject, handles )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


    if any(handles.window)
        
        handles.reference=mean(handles.TemporalERP((101-handles.window):101));
        
    else
        
        handles.reference=0;
        
    end
    
    set(handles.baseline_value,'String',[num2str(-handles.reference)]);
    
    
    handles.TemporalERP=handles.TemporalERP-handles.reference;
    
    
    [b,a]=butter(5,handles.cut_off/(handles.fs/2),'low');
    handles.TemporalERP_filt=filtfilt(b,a,handles.TemporalERP);
    %handles.TemporalERP_filt=handles.TemporalERP_filt-handles.reference;
    
   % if handles.trig2
        
        %If the 'Apply Reference' button has been pressed this will be the
        %value for TemporalERP
        %handles.trig2=0;
        
        if strcmp(get(handles.apply_reference,'Enable'),'off')
        handles.TemporalERP_filt=handles.TemporalERP_filt-handles.Reference_ERP_filt;
        end
        %guidata(hObject,handles);
        
    %end
    
    %Plot the Averaged ERP in the main axis
    axes(handles.temporal);
    plot(handles.TemporalERP_filt);
    
    hold on;
    %Plot stimulus offset line
    plot([101 101],[-20 20],'k--','LineWidth',2);
    hold off;
    text(115,18,'Stimuls Onset','Color','black','FontSize',12,'FontWeight','bold','FontUnit','normalized');
    set(gca,'XTick',[0 100 300 500]);
    set(gca,'XTickLabel',{-0.5 0 1 2},'FontUnit','normalized');
   
    xlabel('Time from Stimulus Onset (seconds)','FontSize',12,'FontUnit','normalized');%,'FontWeight','bold');
    ylabel('EEG Response (\muV)','FontSize',12,'FontUnit','normalized');
    ylim([-20 20]);
    drawnow
    %Once the stimulus has been plotted the user will be allowed to baseline
    %reference

    %if the time window is set to anything but 0 the dotted reference line and overlayed plot line will be plotted
    if any(handles.window)
        
        w=101-handles.window;
        if w<100
            axes(handles.temporal);
            hold on;
            plot([w w],[-20 20],'r:')%,'LineWidth',2)
            plot([0 601], [0 0],'r:');
            text(601,0,'Baseline','Color','red','FontSize',12,'FontUnit','normalized');
            
            hold off;
        end
        
        axes(handles.temporal);
        hold on;
        plot(((101-handles.window):101),handles.TemporalERP_filt((101-handles.window):101),'r','LineWidth',2);
        hold off;
     
    end

    guidata(hObject,handles);

end

