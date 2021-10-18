#!/bin/ksh
begin_time=$SECONDS

input_file=$1
input=`basename $1`
save_loc=$2
# output name stuff, needs to rip appart the input name

echo $save_loc

channel=`echo $input | cut -c 20-21`
year=`echo $input | cut -c 28-31`
day=`echo $input | cut -c 32-34`
hour=`echo $input | cut -c 35-36`
minute=`echo $input | cut -c 37-38`

output="_$hour$minute.cdf"
output="_$day$output"
output="_$year$output"
output="$save_loc/goes_16_channel_$channel$output"

# longitude and latitude mins and maxes
lonmin=-124
lonmax=60

latmin=-16
latmax=37

resolution=20

uniget $input_file > temp1_$minute.cdf

# extract strings for unwanted variable removal
initextrstr="y_image y_image_bounds x_image x_image_bounds geospatial_lat_lon_extent yaw_flip_flag esun focal_plane_temperature_threshhold_exceeded_count std_dev_radiance_value_of_valid_pixels maximum_focal_plane_temperature focal_plane_temperature_threshold_increasing focal_plane_temperature_threshold_decreasing percent_uncorrectable_l0_errors earth_sun_distance_anomaly_in_au algorithm_dynamic_input_data_container processing_parm_version_container algorithm_product_version_container t_star_look band_wavelength_star_look star_id dqf time_bounds focal_plane_temperature_threshold_exceeded_count"


# remove unwanted variables, resize grid to area of interest
# and reorder x & y static fields
cdfextr -r $initextrstr < temp1_$minute.cdf |\
        cdfextr -rs number_of_time_bounds number_of_image_bounds num_star_looks |\
	cdforder x y band |\
	cdfmath "nominal_satellite_subpoint_lat satellite_lat =" |\
	cdfmath "nominal_satellite_subpoint_lon satellite_lon =" |\
	cdfmath "nominal_satellite_height 1000 * satellite_height =" |\
	cdfextr -r "nominal_satellite_height nominal_satellite_subpoint_lon nominal_satellite_subpoint_lat" > temp2_$minute.cdf

gosatellite $latmin $latmax $lonmin $lonmax $resolution < temp2_$minute.cdf |\
	cdfmath "planck_fk1 rad / 1 + log c =" |\
	cdfmath "planck_fk2 c / planck_bc1 - planck_bc2 / temp =" |\
	cdfextr -r "c" | uniput ${output}.nc
rm temp1_$minute.cdf temp2_$minute.cdf
end_time=$SECONDS

echo -e "\tCreated $output\t Elapsed time: $((end_time - begin_time)) seconds"
