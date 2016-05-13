function plot_EEG( data,labels )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
gg=[0.4 0.8 0.4];

ss=get(0,'screensize');
w=ss(3);
h=ss(4);

max_val=mean(max(data(1:7,:),[],2));
 min_val=mean(min(data(1:7,:),[],2));        %Find the maximum and minimum values of EEG response


n= 8+ round((83-8)*rand(7,1));

r=data(n,:);

for i=1:7
   
    r(i,:)=r(i,:)-mean(r(i,:));
    data(i,:)=data(i,:)-mean(data(i,:));
    
    r(i,601)=data(i,1);
   
    if i>1
    r(i,1)=data(i-1,601);
    end
    
end




fig=figure(1);
fig.Position=[w/8 h/8 w*3/4 300];
fig.DockControls='off';
fig.MenuBar='none';
fig.Name='Neural Response to Repeated Stimuli';
fig.NumberTitle='off';


xlim([0 length(data)*7+length(r)*7]);

ylim([min_val-20 max_val+20]);
ax=gca;
ax.XTick=[1000 2000 3000 4000 5000 6000 7000 8000];
ax.XTickLabel=[5 10 15 20 25 30 35 40];
xlabel('Time (s)','FontName','Source Sans Pro');
ylabel('EEG Response (\muV)','FontName','Source Sans Pro');


text(300,-40,labels,'Color',[0.055 0.451 0.7255],'FontSize',30,'FontWeight','bold','FontName','Source Sans Pro');

hold on;

for i=1:7
event{i}=animatedline('Color',gg,'LineWidth',1);
non_event{i}=animatedline('Color','k','LineWidth',1);
end

for x=1:7
   
        for q=1:15:length(r)
       
          
            
        
        addpoints(non_event{x},q+(x-1)*(601+length(r)),r(x,q));
        drawnow
        end
    
            stim=text(3700,-40,'Stimulus','Color',gg,'FontSize',20,'FontWeight','bold','FontName','Source Sans Pro');
            text(601+(x-1)*(601+601)+601/4,40,['ERP ',int2str(x)],'Color',gg,'FontSize',15,'FontWeight','bold','FontName','Source Sans Pro');
            
    for p=1:15:length(data)
   
if p>230
   
    delete(stim);
    
end

    
 
        addpoints(event{x},p+length(r)+(x-1)*(601+length(r)),data(x,p));
        drawnow
    end
    

    

        
end

pause(1);

close(fig);

end

