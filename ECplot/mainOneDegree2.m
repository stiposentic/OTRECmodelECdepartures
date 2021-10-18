

%%
format shortG
close all
%clear all

% This script produces the data averages for figure 10 of the paper
% Required:
% ERA data: ERA5 or operational EC data
% GOES data, explained in another script
% 3D var, as explained in the paper; the 3d var data is attached to this
%     data set 

%AVERAGINGBOX = 1; % used to be 1 by 1 deg boxes
AVERAGINGBOX = 0.5;

UPPER = 2;
LOWER = 0.5;
%UPPER = 1;
%LOWER = 0.2;

SRCMRLIM = 50;
CASESS = 6;
CASESS = 7;
CASESS = 8;

SRCMRLIM = 50;
CASESS = 5;

%SRCMRLIM = 50;
%CASESS = 3;
% 
SRCMRLIM = 500; % doesn't matter here
CASESS = 2;
 SRCMRLIM = 500; % doesn't matter here
 CASESS = 1;
%         if CASESS == 1
%             data000 = data(convInd3 & data(:,1)==j,:);
%         elseif CASESS == 2
%             data000 = data(convInd1 & data(:,1)==j,:);
%         elseif CASESS == 3
%             data000 = data(convInd3 & data(:,1)==j & indEastern,:);
%         elseif CASESS == 4
%             data000 = data(convInd3 & data(:,1)==j & indCarib,:);
%         elseif CASESS == 5
%             data000 = data(convInd3 & data(:,1)==j & indCol,:);
%         elseif CASESS == 6 Northern part of B2
%             data000 = data(convInd3 & data(:,1)==j & indEastern & data(:,4)>=8.5,:);
%         elseif CASESS == 7 Southern part of B2
%             data000 = data(convInd3 & data(:,1)==j & indEastern & data(:,4)<=5.5,:);
%         elseif CASESS == 8 Middle part of B2
%             data000 = data(convInd3 & data(:,1)==j & indEastern & data(:,4)>5.5 & data(:,4)<8.5,:);
%         end



% these files 
files = {...
'20190807_B2.nc',...
'20190811_B1a.nc',...
'20190811_B1b.nc',...
'20190812_B2.nc',...
'20190816_B1a.nc',...
'20190816_B1b.nc',...
'20190817_B2.nc',...
'20190818_B3.nc',...
'20190822_B1a.nc',...
'20190822_B1b.nc',...
'20190823_B2.nc',...
'20190825_B1a.nc',...
'20190825_B1b.nc',...
'20190903_B1a.nc',...
'20190903_B1b.nc',...
'20190904_B2.nc',...
'20190909_B1a.nc',...
'20190909_B1b.nc',...
'20190917_B1c.nc',...
'20190921_B2.nc',...
'20190922_B1c.nc',...
'20190924_B2.nc',...
'20190925_B1c.nc',...
'20190927_B2.nc',...
'20190928_B2.nc',...
'20190930_B2.nc',...
'20191001_B2.nc',...
'20191002_B2.nc'};

data = [];
massflux = NaN(443,81);

count = 1;
for ff = 1: length(files)
    file = cell2mat(files(ff))

lon = ncread(file,'lon');
lat = ncread(file,'lat');
if strcmp(file(1:4),'2019')
    limitsLon = ceil(min(lon)):AVERAGINGBOX:floor(max(lon));
    limitsLat = ceil(min(lat)):AVERAGINGBOX:floor(max(lat));
else
    limitsLon = ceil(min(lon)):1.0:floor(max(lon));
    limitsLat = ceil(min(lat)):1.0:floor(max(lat));
end

z = ncread(file,'sfrac'); z(z>20000) = NaN; sf = double(z);
z = ncread(file,'ii');    z(z>20000) = NaN; ii = double(z);
z = ncread(file,'dcin');  z(z>20000) = NaN; dcin = double(z);
z = ncread(file,'srcmrh'); z(z>20000) = NaN; srcmrh = double(z)/1000;
z = ncread(file,'srcmrv'); z(z>20000) = NaN; srcmrv = double(z)/1000;
z = ncread(file,'srcmr'); z(z>20000) = NaN;  srcmr  = double(z)/1000;
z = ncread(file,'mfluxlo'); z(z>20000) = NaN;  mfluxlo  = double(z);
z = ncread(file,'mfluxhi'); z(z>20000) = NaN;  mfluxhi  = double(z);
mfluxdiff = mfluxhi - mfluxlo;
z = ncread(file,'sst'); z(z>20000) = NaN;  sst  = double(z);
z = ncread(file,'mflux'); z(z>20000) = NaN;  mf  = double(z);
z = ncread(file,'div'); z(z>20000) = NaN;  div  = double(z);
z = ncread(file,'relvort'); z(z>20000) = NaN;  vort  = double(z);
z = ncread(file,'ent'); z(z>20000) = NaN;  ent  = double(z);
z = ncread(file,'satent'); z(z>20000) = NaN;  satent  = double(z);
z = ncread(file,'pres'); z(z>20000) = NaN;  pres  = double(z);
z = ncread(file,'z');

indPlo = pres>700 & pres<900;
indPhi = pres>400 & pres<500;
indPlo = double(indPlo); indPlo(indPlo<0.5) = NaN;
indPhi = double(indPhi); indPhi(indPhi<0.5) = NaN;
satentlo = squeeze(nanmean(satent.*indPlo,1));
satenthi = squeeze(nanmean(satent.*indPhi,1));
iiP = satentlo - satenthi;

indPlo = pres>900 & pres<1100;
indPhi = pres>780 & pres<850;
indPlo = double(indPlo); indPlo(indPlo<0.5) = NaN;
indPhi = double(indPhi); indPhi(indPhi<0.5) = NaN;
entlo = squeeze(nanmean(ent.*indPlo,1));
satenthi = squeeze(nanmean(satent.*indPhi,1));
dcinP = satenthi - entlo;

indZ3to5km = z>=3.0 & z<=5.0;

indZ = z>=0 & z<=.1;
div = squeeze(nanmean(div(indZ,:,:),1));
conv = -div;

z = ncread(file,'w'); z(z>20000) = NaN;  w  = double(z);
z = ncread(file,'rho'); z(z>20000) = NaN;  rho1 = double(z);
temp0  = ncread(file,'temp');  temp0(temp0>10000) = NaN;
pres = ncread(file,'pres'); pres(pres>300000) = NaN;
rho0 = pres *100 ./ (287*(273.15+temp0));
omega = (-9.81) * rho0 .* w;
presInd = pres>830 & pres<865;
presInd = double(presInd);
presInd(presInd<0.5) = NaN;
omega850 = (-1) *squeeze(nanmean(omega.*presInd,1))/150;

[RFnumber, BB, mon, day] = getRFnumber(file);

for i = 1:length(limitsLon)-1
    for j = 1:length(limitsLat)-1
        indLon = lon>= limitsLon(i) & lon<= limitsLon(i+1);
        indLat = lat>= limitsLat(j) & lat<= limitsLat(j+1);
        % get variable averages if number of NaNs less than 50%
        numOfNaNs = sum(sum(isnan(ii(indLat,indLon))));
        numOfData = sum(sum(ii(indLat,indLon)<10^7));
        precNumOfNaNs = numOfNaNs/numOfData;
        if precNumOfNaNs < 0.5
            iiD = nanmean(ii(indLat,indLon),'all');
            sfD = nanmean(sf(indLat,indLon),'all');
            dcinD = nanmean(dcin(indLat,indLon),'all');
            srcmrD = nanmean(srcmr(indLat,indLon),'all');
            mfloD = nanmean(mfluxlo(indLat,indLon),'all');
            mfhiD = nanmean(mfluxhi(indLat,indLon),'all');
            mfdiffD = nanmean(mfluxdiff(indLat,indLon),'all');
            sstD = nanmean(sst(indLat,indLon),'all');
            vortD = nanmean(vort(indZ3to5km,indLat,indLon),'all');
            iiPD = nanmean(iiP(indLat,indLon),'all');
            dcinPD = nanmean(dcinP(indLat,indLon),'all');
            if RFnumber == 99
                sstD = sstD + 273.15;
            end
            convD = nanmean(conv(indLat,indLon),'all');
            omega850D = nanmean(omega850(indLat,indLon),'all');
            data = [data; RFnumber BB limitsLon(i)+AVERAGINGBOX/2 limitsLat(j)+AVERAGINGBOX/2 ...
                iiD sfD dcinD srcmrD mfloD mfhiD mfdiffD sstD convD...
                omega850D vortD mon day dcinPD iiPD];
            massflux(count,:) = squeeze(nanmean(nanmean(mf(:,indLat,indLon),3),2));
            count = count + 1;
        end
    end
end
%data = double(data);

end
z = ncread(file,'z');

% For PREDICT cases RF = 99, BB = 9

% BB  BOX 
% 1   B2
% 2   B1a
% 3   B1b
% 4   B1c
% 5   B3 
% 9 PREDICT

%   1       2  3                4 
% RFnumber BB limitsLon(i)+0.5 limitsLat(j)+0.5 ...

%  5   6   7       8      9    10   11      12    13      14     15 
% iiD sfD dcinD srcmrD mfloD mfhiD mfdiffD sstD  convD  omega850 vortD];

% 16 17     18     19
% mon day  dcinPD iiPD

positions = data(data(:,1)<90,3:4);

%plot(positions(:,1),positions(:,2),'k.')
%stop

% exclude 08/07 and 08/11, because we don;t have 12UTC for 08/07
data(data(:,16)==8 & data(:,17)==7,:) = [];



% only convective cases: moisture conv > 0.2, and OTREC
convInd1 = data(:,1)<90 & data(:,8)<LOWER;
convInd2 = data(:,1)<90 & data(:,8)>=LOWER & data(:,8)<UPPER;
convInd3 = data(:,1)<90 & data(:,8)>UPPER;
% PREDICT cases
convInd1p = data(:,1)>90 & data(:,8)<LOWER;
convInd2p = data(:,1)>90 & data(:,8)>=LOWER & data(:,8)<UPPER;
convInd3p = data(:,1)>90 & data(:,8)>UPPER;







brightGOESD = [];

dcinDOPAN =  [];
vort700DOPAN =  [];
iiDOPAN =    [];
sfDOPAN =    [];
srcmrDOPAN = [];
rfluxDOPAN = [];
u10DOP = [];
v10DOP = [];
uu10DOP = [];
srcmr12DOPAN = [];
srcmr17DOPAN = [];


if 1
    figure
    set(gcf,'Position',[70 0 700 900])
    Ntotal=0;
    for j = 1:20
        j
        %CASESS = 1;
        % BB  BOX
        % 1   B2
        % 2   B1a
        % 3   B1b
        % 4   B1c
        % 5   B3
        % 9 PREDICT
        indEastern = data(:,2)==1;
        % choose only colombian south of 9 degrees
        onlyB1a = data(:,1)<90 & data(:,4)<8.25;
        onlyB1b = data(:,1)<90 & data(:,4)>9.25;
        indCarib = onlyB1b & (data(:,2)==3 | data(:,2)==4);
        indCol   = onlyB1a & (data(:,2)==2 | data(:,2)==4);
        if CASESS == 1
            data000 = data(convInd3 & data(:,1)==j,:);
        elseif CASESS == 2
            data000 = data(convInd1 & data(:,1)==j,:);
        elseif CASESS == 3
            data000 = data(convInd3 & data(:,1)==j & indEastern,:);
        elseif CASESS == 4
            data000 = data(convInd3 & data(:,1)==j & indCarib,:);
        elseif CASESS == 5
            data000 = data(convInd3 & data(:,1)==j & indCol,:);
        elseif CASESS == 6
            data000 = data(convInd3 & data(:,1)==j & indEastern & data(:,4)>=8.5,:);
        elseif CASESS == 7
            data000 = data(convInd3 & data(:,1)==j & indEastern & data(:,4)<=5.5,:);
        elseif CASESS == 8
            data000 = data(convInd3 & data(:,1)==j & indEastern & data(:,4)>5.5 & data(:,4)<8.5,:);
        end
        time = 0:23;
        N=0;
        for i = 1:size(data000,1)
            mon = data000(i,16);
            day = data000(i,17);
            lonR = data000(i,3);
            latR = data000(i,4);
            
            fileOPAN = [ 'E:\OPAN\otrec_1_pl_2019' ...
                num2str(mon,'%.2i') num2str(day,'%.2i') '00.cdf.nc' ];
            fileOPANsfc = [ 'E:\OPAN\MSLentflux_otrec_1_sfc_2019' ...
                num2str(mon,'%.2i') num2str(day,'%.2i') '00.nc' ];
            lonOPAN    = ncread(fileOPAN,'lon');
            latOPAN    = ncread(fileOPAN,'lat');
            dcinOPAN = ncread(fileOPAN,'dcin');
            vort700OPAN = ncread(fileOPAN,'vort700');
            iiOPAN   = ncread(fileOPAN,'ii');
            sfOPAN   = ncread(fileOPAN,'sfrac');
            srcmrOPAN = ncread(fileOPAN,'srcmr');
            srcmr3D_OPAN = ncread(fileOPAN,'srcmr3D');
            level3D_OPAN = ncread(fileOPAN,'levelD');
            lonOPANsf    = ncread(fileOPANsfc,'lon');
            latOPANsf    = ncread(fileOPANsfc,'lat');
            rfluxOPAN    = ncread(fileOPANsfc,'rflux'); rfluxEC(rfluxEC>10000) = NaN;
            u10OP  = ncread(fileOPANsfc,'u10'); u10OP(u10OP>10000) = NaN; 
            v10OP  = ncread(fileOPANsfc,'v10'); v10OP(v10OP>10000) = NaN; 
            uu10OP  = ncread(fileOPANsfc,'UU10'); uu10OP(uu10OP>10000) = NaN; 
         
            

            %if (mon==8 && day==17) || (mon==8 && day==18) || (mon==9 && day==22)
            %    brightGOES = NaN(24,1);
            %else
                fileIN = ['E:\GOES16\goes_16_channel_14_2019' num2str(mon,'%.2i') num2str(day,'%.2i') '.nc'];
                lonGOES    = ncread(fileIN,'lon');
                latGOES    = ncread(fileIN,'lat');
                brightGOES = ncread(fileIN,'temp');
                brightGOES(brightGOES>10000) = NaN;
                indLon = lonGOES>lonR-0.5 & lonGOES<lonR+0.5;
                indLat = latGOES>latR-0.5 & latGOES<latR+0.5;
                brightGOES = squeeze(mean(nanmean(brightGOES(:,indLat,indLon),2),3));
            %end
            
           
            
            indLon = lonOPAN>lonR-0.5 & lonOPAN<lonR+0.5;
            indLat = latOPAN>latR-0.5 & latOPAN<latR+0.5;
            dcinOPAN = squeeze(mean(mean(dcinOPAN(:,indLat,indLon),2),3));
            vort700OPAN = squeeze(mean(mean(vort700OPAN(:,indLat,indLon),2),3));
            iiOPAN = squeeze(mean(mean(iiOPAN(:,indLat,indLon),2),3));
            sfOPAN = squeeze(mean(mean(sfOPAN(:,indLat,indLon),2),3));
            srcmrOPAN = squeeze(mean(mean(srcmrOPAN(:,indLat,indLon),2),3));
            rfluxOPAN = squeeze(mean(mean(rfluxOPAN(:,indLat,indLon),2),3));
            u10OP = squeeze(mean(mean(u10OP(:,indLat,indLon),2),3));
            v10OP = squeeze(mean(mean(v10OP(:,indLat,indLon),2),3));
            uu10OP = squeeze(mean(mean(uu10OP(:,indLat,indLon),2),3));
            srcmr3D12UTC_OP = squeeze(mean(mean(srcmr3D_OPAN(:,12,indLat,indLon),3),4));
            srcmr3D17UTC_OP = squeeze(mean(mean(srcmr3D_OPAN(:,17,indLat,indLon),3),4));
           
       
            
         
            if any(srcmr/1000 > SRCMRLIM) %|| data000(i,1)==14 || data000(i,1)==11 || data000(i,1)==19
                data000(i,:)
                continue
            end
            
            brightGOESD =    [brightGOESD brightGOES];
            
            dcinDOPAN =  [dcinDOPAN dcinOPAN];
            vort700DOPAN =  [vort700DOPAN vort700OPAN];
            iiDOPAN =    [iiDOPAN     iiOPAN];
            sfDOPAN =    [sfDOPAN sfOPAN];
            srcmrDOPAN = [srcmrDOPAN srcmrOPAN];
            rfluxDOPAN = [rfluxDOPAN rfluxOPAN];
            u10DOP = [u10DOP u10OP];
            v10DOP = [v10DOP v10OP];
            uu10DOP = [uu10DOP uu10OP];
            srcmr12DOPAN = [srcmr12DOPAN srcmr3D12UTC_OP];
            srcmr17DOPAN = [srcmr17DOPAN srcmr3D17UTC_OP];
          
            
            % %figure('visible','off')
            % %set(gcf,'Position',[70 0 700 900])
            % subplot(5,1,1)
            % plot(time,dcin,'k'); hold on;
            % %plot(time,dcin*0+data000(i,18),'r');
            % title(['date: ' num2str(mon) '/' num2str(day) ...
                % ', case ' num2str(i) 'out of ' num2str(size(data000,1)) ...
                % ', lon ' num2str(lonR) ', lat ' num2str(latR)])
            % ylabel('DCIN (J/K/kg)')
            % xlim([0 23]); set(gca,'fontsize',12)
            % subplot(5,1,2)
            % plot(time,sf,'k'); hold on;
            % %plot(time,dcin*0+data000(i,6),'r');
            % ylabel('saturation fraction')
            % xlim([0 23]); set(gca,'fontsize',12)
            % subplot(5,1,3)
            % plot(time,ii,'k'); hold on;
            % %plot(time,dcin*0+data000(i,19),'r');
            % ylabel('instability index (J/K/kg)')
            % xlim([0 23]);set(gca,'fontsize',12)
            % subplot(5,1,4)
            % plot(time,srcmr/1000,'k'); hold on;
            % %plot(time,dcin*0+data000(i,8),'r');
            % ylabel('moisture conv. (kW/m^2)')
            % xlim([0 23])
            % set(gca,'fontsize',12)
            % subplot(5,1,5)
            % plot(time,rflux,'k'); hold on;
            % %plot(time,dcin*0+data000(i,8),'r');
            % ylabel('mr flux (W/m^2)')
            % xlabel('UTC time (h)')
            % xlim([0 23])
            % set(gca,'fontsize',12)
            %print('-dpng',['PREDCIN_'  num2str(mon,'%.2i') num2str(day,'%.2i') ...
            %    '_case_' num2str(i) '_outOf_' num2str(size(data000,1)) ...
            %    '.png'])
			
            N = N + 1;
            Ntotal = Ntotal + 1;
            
        end
        [j N]
    end
    Ntotal
        % figure
        % subplot(5,1,1)
        % plot(time,mean(dcinD',1),'r'); hold on;
        % %plot(time,dcin*0+data000(i,18),'r');
        % %title(['date: ' num2str(mon) '/' num2str(day) ...
        % %    ', case ' num2str(i) 'out of ' num2str(size(data000,1)) ...
        % %    ', lon ' num2str(lonR) ', lat ' num2str(latR)])
        % title('averaged over all individual cases')
        % ylabel('DCIN (J/K/kg)')
        % xlim([0 23]); set(gca,'fontsize',12)
        % subplot(5,1,2)
        % plot(time,mean(sfD',1),'r'); hold on;
        % %plot(time,dcin*0+data000(i,6),'r');
        % ylabel('saturation fraction')
        % xlim([0 23]); set(gca,'fontsize',12)
        % subplot(5,1,3)
        % plot(time,mean(iiD',1),'r'); hold on;
        % %plot(time,dcin*0+data000(i,19),'r');
        % ylabel('instability index (J/K/kg)')
        % xlim([0 23]);set(gca,'fontsize',12)
        % subplot(5,1,4)
        % plot(time,mean(srcmrD'/1000,1),'r'); hold on;
        % %plot(time,dcin*0+data000(i,8),'r');
        % ylabel('moisture conv. (kW/m^2)')
        % xlim([0 23])
        % set(gca,'fontsize',12)
        % subplot(5,1,5)
        % plot(time,nanmean(rfluxD',1),'r'); hold on;
        % %plot(time,dcin*0+data000(i,8),'r');
        % ylabel('mr flux (W/m^2)')
        % xlabel('UTC time (h)')
        % xlim([0 23])
        % set(gca,'fontsize',12)
        if CASESS == 1
            fileName = 'convective.mat';
        elseif CASESS == 2
            fileName = 'nonconvective.mat';
        elseif CASESS == 3
            fileName = 'convectiveB2.mat';
        elseif CASESS == 4
            fileName = 'convectiveB1b.mat';
        elseif CASESS == 5
            fileName = 'convectiveB1a.mat';
        elseif CASESS == 6
            fileName = 'convectiveB2north.mat';
        elseif CASESS == 7
            fileName = 'convectiveB2south.mat';
        elseif CASESS == 8
            fileName = 'convectiveB2middle.mat';
        end
        save(fileName,'time',...
        'dcinDOPAN','iiDOPAN','sfDOPAN','srcmrDOPAN','rfluxDOPAN','u10DOP','v10DOP','uu10DOP', 'brightGOESD','vort700DOPAN')
    
    
  


end


% after running the above script for each convective regime
% plot figure 1 from paper
%plotSnip0

