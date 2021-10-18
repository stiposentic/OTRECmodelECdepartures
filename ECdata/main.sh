#/bin/ksh

dirIN='~/ecNODPSND/OLD_BACKUP/OPAN/'
dirOUT='~/ECanalysis/'

hours='01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25'

a=111210

cd $dirIN
files=`ls otrec_*_pl_*00.nc`
cd $dirOUT

echo $files
echo working...

for file in $files
do

  for hour in $hours
  do

  len=${#file} 
  endstr=`echo "$len - 3" | bc`
  fileNAME=`echo $file | cut -c 1-$endstr`  
  echo ${dirIN}$file, $fileNAME, $hour
  
  TIME=`echo $hour | bc`
  cdo seltimestep,$TIME ${dirIN}$file tmp

  uniget tmp |\
  cdforder longitude latitude level |\
  cdfmath "longitude lon =" |\
  cdfmath "latitude lat =" |\
  cdfinvindex longitude lon |\
  cdfinvindex latitude lat |\
  cdfmath "q 1 q - / 1000 * mr =" |\
  cdfmath "t 0 * level + pres =" |\
  cdfmath "t 273.15 - temp =" |\
  cdfmath "pres 100 * t / 287 / rho =" |\
  cdfmath "w rho * massfluxPreSmooth =" |\
  cdfentropy -q pres temp mr ent satmr |\
  cdfentropy -d pres temp temp satent satmr |\
  cdfmath "w rho * massflux =" |\
  cdfmath "u lat cos * cfx =" |\
  cdfderiv dcfxdlat cfx lat |\
  cdfderiv dfydlon v lon |\
  cdfmath "dfydlon dcfxdlat - 111.2 / lat cos / vort ="|\
  cdfmath "v lat cos * cv =" |\
  cdfderiv dudlon u lon |\
  cdfderiv dcvdlat cv lat |\
  cdfmath "dudlon dcvdlat + 111.2 / lat cos / div =" > thermo.cdf

  echo gms
  cat thermo.cdf |\
	  cdfextr ent mr u v w rho |\
	  cdfinterp level 1000 -25 37 |\
	  avapsngms.sh > gms.cdf
	
  echo gms3D
  cat thermo.cdf |\
	  cdfextr ent mr u v w rho |\
	  cdfinterp level 1000 -25 37 |\
	  avapsngms3D.sh > gms3D.cdf


  echo massflux
  cat thermo.cdf |\
	  cdfextr massfluxPreSmooth massflux div vort mr rho > massflux.cdf

  echo mrp
  cat thermo.cdf |\
	  cdfextr mr|\
	  cdfinterp level 1000 -25 37 |\
	  cdfderiv mrp mr level |\
	  cdfmath "level levelD =" |\
	  cdfinvindex level levelD |\
	  cdfextr -r level |\
	  cdfextr mrp > mrp.cdf

  echo u and v
  cat thermo.cdf |\
	  cdfextr u v vort div |\
	  cdfrdim level 700 |\
	  cdfmath "u u700 =" |\
	  cdfmath "v v700 ="|\
	  cdfmath "vort vort700 =" |\
	  cdfmath "div div700 =" |\
	  cdfextr u700 v700 div700 vort700 |\
	  cdfextr -rs level > uv.cdf

  echo sf
    # compute saturation fraction
    cat thermo.cdf | \
	cdfextr mr satmr |\
	cdfinterp level 1000 -25 37 |\
	cdfdefint level | \
	cdfmath "mr satmr / sfrac =" | \
	cdfextr -rs level | \
	cdfextr sfrac > sfrac.cdf
  echo ii
    # compute instability index
    cat thermo.cdf |\
	cdfextr satent |\
        cdfrdim level 700 900 >  temp3
    cat thermo.cdf |\
	cdfextr satent |\
	cdfrdim level 400 500 > temp4
    cdfmerge temp3 '' temp4 '' | \
	cdfmath 'satent satent. - ii =' | \
	cdfmath "satent iilw =" |\
	cdfmath "satent. iihi =" |\
	cdfextr -rs level | \
	cdfextr iilw iihi ii > ii.cdf
	
  echo dcin
    # compute dcin
     cat thermo.cdf | cdfextr ent | cdfrdim level 900 1000 | cdfmath 'ent entlo =' | cdfextr -rs level | cdfextr entlo > tmpdcinlo.cdf
     cat thermo.cdf | cdfextr satent | cdfrdim level 800 850 | cdfmath 'satent enthi =' | cdfextr -rs level | cdfextr enthi > tmpdcinhi.cdf
     cdfmerge tmpdcinlo.cdf '' tmpdcinhi.cdf '' | cdfmath 'enthi entlo - dcin =' | cdfextr dcin > dcin.cdf

  cdfmerge sfrac.cdf '' ii.cdf '' dcin.cdf '' uv.cdf '' gms.cdf '' gms3D.cdf ''  massflux.cdf '' mrp.cdf ''|\
	  cdfextr -s lon lat level levelD |\
	  cdfmath "$hour 1 - time =" > ${dirOUT}${fileNAME}_${hour}.cdf
	  #uniput ${dirOUT}${fileNAME}_${hour}.nc

  done
  cdfcatf ${fileNAME}_*.cdf |\
    cdfcat time 0 30 40 |\
    cdforder lon lat time level levelD |\
    uniput ${fileNAME}.nc

  rm *.cdf 
done
