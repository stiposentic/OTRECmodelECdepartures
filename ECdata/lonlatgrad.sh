#!/bin/sh
#
# lonlatgrad.sh -- Compute the horizontal gradient on a sphere
#
if test $# != 5
then
    echo "Usage: lonlatgrad.sh lon lat chi gradx grady"
else
    lon=$1
    lat=$2
    chi=$3
    gradx=$4
    grady=$5

    a=111.2
    
    # compute the gradient and be sure that both components are
    # either good or bad
    cdfderiv dchidlon $chi $lon | \
	cdfderiv dchidlat $chi $lat | \
	cdfmath "dchidlon $a / $lat cos / $gradx =" | \
	cdfmath "dchidlat $a / $grady =" | \
	cdfextr -r dchidlon dchidlat | \
	cdfmath "$gradx $grady 0 * + $gradx =" | \
	cdfmath "$grady $gradx 0 * + $grady ="
fi
