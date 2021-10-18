

timeOPAN = 0:24;
timeGOES = 0:23;


    subplot(5,1,1)
      plot(timeOPAN,nanmean(srcmrDOPAN'/1000,1),cLine5,'linewidth',LINEWIDTH); hold on;
      ylabel({'moisture conv.'; '(kW/m^2)'})
      xlim([0 23])
      set(gca,'fontsize',12)
      plot([12 12],[-0.5 1.6],'k')
      plot([18 18],[-0.5 1.6],'k')
      ylim([-0.2 1.5])
    subplot(5,1,2)
      plot([12 12],[225 280],'k'); hold on
      plot([18 18],[225 280],'k');
      plot(timeGOES,nanmean(brightGOESD',1),cLine,'linewidth',LINEWIDTH); hold on;
      ylabel({'brightness'; 'temp. (K)'})
      xlim([0 23])
      set(gca,'fontsize',12)
      %ylim([235 267])
      ylim([225 280])
    subplot(5,1,3)
      plot(timeOPAN,mean(sfDOPAN',1),cLine5,'linewidth',LINEWIDTH); hold on;
      ylabel({'saturation'; 'fraction'})
      xlim([0 23]); set(gca,'fontsize',12)
      plot([12 12],[0.72 0.88],'k')
      plot([18 18],[0.72 0.88],'k')
      %ylim([0.77 0.88])
      ylim([0.72 0.88])
    subplot(5,1,4)
      plot(timeOPAN,mean(iiDOPAN',1),cLine5,'linewidth',LINEWIDTH); hold on;
      ylabel({'instability'; 'index (J/K/kg)'})
      xlim([0 23]);set(gca,'fontsize',12)
      plot([12 12],[4 22],'k')
      plot([18 18],[4 22],'k')
      ylim([5 22])
   subplot(5,1,5)
      plot(timeOPAN,mean(dcinDOPAN',1),cLine5,'linewidth',LINEWIDTH); hold on;
      ylabel('DCIN (J/K/kg)')
      xlim([0 23]); set(gca,'fontsize',12)
      plot([12 12],[-4 13],'k')
      plot([18 18],[-4 13],'k')
      ylim([-4 11])
      xlabel('UTC time (h)')