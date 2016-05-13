function [hObject, handles]=reference_plotting1( hObject, handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
 if ~isempty(handles.c)

    
    [handles.Reference_ERP,f]=averaging_erps(mean(handles.ERP(handles.c,:,:),1),handles);
    
    %handles.Reference_ERP
    
    if isempty(f)
        set(handles.selection_check2,'Visible','on');
        set(handles.apply_reference,'Enable','off');
        cla(handles.reference_plot)
        
    else if length(f)==1
            
        else
            handles.Reference_ERP=mean(handles.Reference_ERP);
            
        end
        
       
        [b,a]=butter(5,handles.cut_off/(handles.fs/2),'low');
        handles.Reference_ERP_filt=filtfilt(b,a,handles.Reference_ERP);
        
        if handles.window
            handles.reference1=mean(handles.Reference_ERP_filt((101-handles.window):101));
        else
            handles.reference1=0;
        end
        
        handles.Reference_ERP_filt=handles.Reference_ERP_filt-handles.reference1;

        
        axes(handles.reference_plot);
        plot(handles.Reference_ERP_filt,'Color',[0.094 0.663 0.184]);
        ylim([-20 20]);
        xlim([0 601]);
        set(gca,'XTick',[],'YTick',[],'XColor',[1 1 1],'YColor',[1 1 1],'FontUnit','normalized');
        %set(gca,'XTickLabel',{-0.5 0 1 2});
        xlabel('time (seconds)','FontUnit','normalized','FontName','Source Sans Pro'); ylabel('\muV','FontUnit','normalized','FontName','Source Sans Pro');
        title('Reference','Color',[1 1 1],'FontUnit','normalized','FontName','Source Sans Pro')
        
        
    end
    
 end
%handles.Reference_ERP_filt

%handles = guidata(hObject);
%guidata(hObject,handles);

end

