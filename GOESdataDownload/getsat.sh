#!/bin/ksh

band="14"

# Google S3 Bucket
server="gs://gcp-public-data-goes-16"
# Full disk data
data="ABI-L1b-RadF"
# cloud top temperature
data="ABI-L2-ACHTF"

# time Range Selection
year="2020"
# August 1, 2019
startday=255

#startday=273
# September 30, 2019
endday=261

# every hour
set -A hours 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
#set -A hours 16
# every 3 hours
#set -A hours 00 03 06 09 12 15 18 21
# every 6 hours
#set -A hours 00 06 12 18

# The data comes as an image every few minutes, 00 is the start of the hour
# images come either every 10 or 15 minutes
# by default the first image of the hour is downloaded
minute="0*"
# enable this to download all images for an hour
#minute="*"

regex="_G16_s"

rm $PWD/downloads/*.nc
day=$startday
while (( $day < $endday + 1))
do
	for hour in ${hours[@]};
	do
		hourly_dir="$PWD/rawsat/$day/$hour"
		mkdir -p $hourly_dir
		gsutil ls "$server/$data/$year/$day/$hour/OR_ABI-L2-ACHTF-M6$band$regex$year$day$hour$minute.nc" | gsutil -m cp -I ./downloads
		#gsutil ls "$server/$data/$year/$day/$hour/OR_ABI-L1b-RadF-M6C$band$regex$year$day$hour$minute.nc" | gsutil -m cp -I ./downloads
		downloads=`ls -d $PWD/downloads/*`
		mv downloads/*.nc $hourly_dir
		#for ncfile in $downloads;
		#do
	#		./goes16_cdf.sh $ncfile $hourly_dir & 
		#done
		#wait
		#rm $PWD/downloads/*.nc
	done
	((day=$day+1))
done
