
#files=`ls goes*.cdf`
#for file in $files
#do
#	echo $file
#	cat $file |\
#		uniput -r ${file}.nc
#done
#exit




DIR0=/home/pi/Desktop/goes16

cd rawsat/
dirs=`ls -d *`
cd ../

dirs=`seq 265 280`

for dir in $dirs
do
	cd $DIR0/rawsat/$dir/
	hours=`ls -d */`
	for hour in $hours
	do
		echo $dir, $hour
		cd $DIR0/rawsat/$dir/$hour/
		file=`ls *.nc`
		echo $file
		cd $DIR0
		goes16_cdf.sh $DIR0/rawsat/$dir/$hour/$file $DIR0
		cat $file |\
                   uniput -r ${file}.nc
	done
done
