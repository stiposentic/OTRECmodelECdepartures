function [RFnumber, BB, month, dayy] = getRFnumber(file)

year = file(1:4);
mon = file(5:6);
day = file(7:8);
if strcmp(year,'2010')
    RFnumber = 99;
    BB = 9;
    month = str2num(mon);
    dayy = str2num(day);
    return;
end
box = file(10:12);


if strcmp(mon,'08')
    month = 8;
    if strcmp(day,'07'); RFnumber = 1; dayy = 7;  end
    if strcmp(day,'11'); RFnumber = 2; dayy = 11; end
    if strcmp(day,'12'); RFnumber = 3; dayy = 12; end
    if strcmp(day,'16'); RFnumber = 4; dayy = 16; end
    if strcmp(day,'17'); RFnumber = 5; dayy = 17; end
    if strcmp(day,'18'); RFnumber = 6; dayy = 18; end
    if strcmp(day,'22'); RFnumber = 7; dayy = 22; end
    if strcmp(day,'23'); RFnumber = 8; dayy = 23; end
    if strcmp(day,'25'); RFnumber = 9; dayy = 25; end 
elseif strcmp(mon,'09')
    month = 9;
    if strcmp(day,'03'); RFnumber = 10; dayy = 3; end 
    if strcmp(day,'04'); RFnumber = 11; dayy = 4; end 
    if strcmp(day,'09'); RFnumber = 12; dayy = 9; end 
    if strcmp(day,'17'); RFnumber = 13; dayy = 17; end 
    if strcmp(day,'21'); RFnumber = 14; dayy = 21; end 
    if strcmp(day,'22'); RFnumber = 15; dayy = 22; end 
    if strcmp(day,'24'); RFnumber = 16; dayy = 24; end 
    if strcmp(day,'25'); RFnumber = 17; dayy = 25; end 
    if strcmp(day,'27'); RFnumber = 18; dayy = 27; end 
    if strcmp(day,'28'); RFnumber = 19; dayy = 28; end 
    if strcmp(day,'30'); RFnumber = 20; dayy = 30; end 
elseif strcmp(mon,'10')
    month = 10;
    if strcmp(day,'01'); RFnumber = 21; dayy = 1; end 
    if strcmp(day,'02'); RFnumber = 22; dayy = 2; end 
end


% BB  BOX 
% 1   B2
% 2   B1a
% 3   B1b
% 4   B1c
% 5   B3 

if strcmp(box,'B2.')
   BB = 1;
elseif strcmp(box,'B1a')
    BB = 2;
elseif strcmp(box,'B1b')
    BB = 3;
elseif strcmp(box,'B1c')
    BB = 4;
elseif strcmp(box,'B3.')
    BB = 5;
end

   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
