#!/bin/sh
#
# avapsngms.sh -- Compute vertically integrated moist entropy
# divergence and water vapor convergence -- this is a filter.
# Vertical and horizontal parts are computed separately.  The
# numerical factors put results in SI units.  Results are converted to
# energy units.
# here we integrate in pressure (hPa), so we need to multiply by 100
# but also divide by 1000 because of d/dx and d/dy were in 1/km
# so net divide by 10
# w is in Pa/s
# 
L=2.5e6
TREF=300

cdfextr ent mr u v w |\
lonlatgrad.sh lon lat ent entx enty | \
    lonlatgrad.sh lon lat mr mrx mry | \
    cdfderiv entp ent level | \
    cdfderiv mrp mr level | \
    cdfmath "u entx * v enty * + $TREF * -9.81 / 10 / srcenth =" |\
    cdfmath "u mrx * v mry * + -1e-3 * $L * -9.81 / 10 / srcmrh =" | \
    cdfmath "w entp * $TREF * -9.81 / srcentv =" | \
    cdfmath "w mrp * -1e-3 * $L * -9.81 / srcmrv =" | \
    cdfmath "srcenth srcentv + srcent =" | \
    cdfmath "srcmrh srcmrv + srcmr =" | \
    cdfdefint level | \
    cdfextr -s lon lat | \
    cdfextr -p lon0 dlon lat0 dlat | \
    cdfextr srcenth srcentv srcent srcmrh srcmrv srcmr
