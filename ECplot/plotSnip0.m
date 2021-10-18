
clear all
close all

% figure
% set(gcf,'Position',[70 0 700 900])
% load nonconvective.mat;
% cLine = 'r';
% cLine2 = 'r--';
% cLine3 = 'b--';
% cLine4 = 'g--';
% cLine5 = 'r';
% TITLESUFF = 'nonconvective, ';
% plotSnip1
      
figure
set(gcf,'Position',[70 0 700 900])
load convective.mat;
LINEWIDTH = 2;
cLine = 'r';
cLine5 = 'r';
TITLESUFF = '';
plotSnip1

load nonconvective.mat;
cLine = 'k';
cLine5 = 'k';
TITLESUFF = '';
plotSnip1

load convectiveB2.mat;
cLine = 'b';
cLine5 = 'b';
TITLESUFF = '';
plotSnip1

load convectiveB1a.mat;
cLine = 'g';
cLine5 = 'g';
TITLESUFF = '';
plotSnip1


subplot(5,1,1)
%hh = legend('convective all', 'non-convective','B2', 'B1a','Location','Northwest');
[~, hobj, ~, ~] = legend('convective all', 'non-convective','B2', 'B1a','Location','Northwest');
hl = findobj(hobj,'type','line');
set(hl,'LineWidth',2);
set(hl(5),'Color','b')
set(hl(7),'Color','g')
text(7.5,1.3,'a','fontsize',14)

subplot(5,1,2); text(1,237,'b','fontsize',14)
subplot(5,1,3); text(1,0.85,'c','fontsize',14)
subplot(5,1,4); text(1,9,'d','fontsize',14)
subplot(5,1,5); text(1,-1,'e','fontsize',14)

%print('-dpng',['FINAL_figure10.png'])
%print('-depsc',['FINAL_figure10.eps'])

