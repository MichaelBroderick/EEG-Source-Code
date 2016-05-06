function [ERP,f]=averaging_erps(erp_set,handles)

s=squeeze(erp_set);

meanERP(1,:)=mean(s(1:7,:));
meanERP(2,:)=mean(s(8:14,:));
meanERP(3,:)=mean(s(15:21,:));
meanERP(4,:)=mean(s(22:28,:));

 e(1)=get(handles.erp_radio_1to7,'Value');
 e(2)=get(handles.erp_radio_8to14,'Value');
 e(3)=get(handles.erp_radio_15to21,'Value');
 e(4)=get(handles.erp_radio_22to28,'Value');
 
f=find(e);
 
 ERP=meanERP(f,:);
 
