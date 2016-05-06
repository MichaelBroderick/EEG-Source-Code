function []=btopoplot(V,ChXX,ChYY,myClim)
% example: btopoplot_Michael(randn(1,128).',ChXX,ChYY,[-1 1])
R=100;
guidewidth=0.025;
myfontsize=10;

L=length(ChXX);
       
MapLineWidth=0.5;
ti=-100:1:100;
[qx,qy] = meshgrid(ti,ti);

Vn=V.';%(V-nanmean(V))./nanmean(V);
Vn(isnan(Vn))=0;
F = scatteredInterpolant(ChXX.', ChYY.',Vn);
qz = F(qx,qy);
plotR=100;
qz((qx.^2+qy.^2)>(100.^2))=NaN;

topo=pcolor(ti,ti,qz); shading flat;caxis(myClim);
         set(gca,'YDir','normal');
uistack(topo,'bottom');
%alpha(0.7)
hold on
%contour(qx, qy, qz,15,'k');
plottheta=0:0.001:(2.01*pi);
Yoffset=0;
%Plot the Head
plot(plotR.*cos(plottheta),plotR.*sin(plottheta)-Yoffset,'Color','k','LineWidth',2);
eartheta=(0.4*pi):0.001:(1.6*pi);
%Plot the Ear
plot(-plotR+cos(eartheta)*10,25.*sin(eartheta)-Yoffset,'Color','k','LineWidth',2);
plot(plotR-cos(eartheta)*10,25.*sin(eartheta)-Yoffset,'Color','k','LineWidth',2);
plot(plotR.*cos(2*pi*(0.25+[-0.015 0 0.015])),plotR.*sin(2*pi*(0.25+[-0.015 0 0.015]))-Yoffset+[0 15 0],'Color','k','LineWidth',2);
xlim(115.*[-1 1]);
ylim(115.*[-1 1]);
%plot(ChXX(1:L),ChYY(1:L),'Color',[1 1 1]-1,'Marker','.','MarkerSize',4,'LineStyle','none');
set(gca, 'YTick', [], 'XTick', [], 'YTickLabel', [], 'XTickLabel', []);
% Head Cuircle
hold on
plot(plotR.*cos(plottheta),plotR.*sin(plottheta)-Yoffset,'Color','k','LineWidth',MapLineWidth);
eartheta=(0.4*pi):0.001:(1.6*pi);
plot(-plotR+cos(eartheta)*10,25.*sin(eartheta)-Yoffset,'Color','k','LineWidth',MapLineWidth);
plot(plotR-cos(eartheta)*10,25.*sin(eartheta)-Yoffset,'Color','k','LineWidth',MapLineWidth);
plot(plotR.*cos(2*pi*(0.25+[-0.015 0 0.015])),plotR.*sin(2*pi*(0.25+[-0.015 0 0.015]))-Yoffset+[0 15 0],'Color','k','LineWidth',MapLineWidth);
colormap(hot);
% dots:
%plot(ChXX(1:L),ChYY(1:L),'Color',[0 0 0],'LineStyle','none','Marker','.','MarkerSize',1);
%plot([-1 1].*R,[0 0],'LineWidth',guidewidth,'Color',[0 0 0]);
%plot([0 0],[-1 1].*R,'LineWidth',guidewidth,'Color',[0 0 0]);


%topoplot