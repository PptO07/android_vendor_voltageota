#!/bin/bash
#put script in VoltageOS source folder, make executable (chmod +x createjson.sh) and run it (./createjson.sh)

#modify values below
#leave blank if not used
maintainer="Name (nickname)" #ex: Lup Gabriel (gwolfu)
oem="OEM" #ex: OnePlus
device="device codename" #ex: guacamole
devicename="name of device" #ex: OnePlus 7 Pro
zip="voltage zip" #ex: voltageos-<android version>-<date>-<device codename>-v<voltage version>.zip

#don't modify from here
script_path="`dirname \"$0\"`"
zip_name=$script_path/out/target/product/$device/$zip
buildprop=$script_path/out/target/product/$device/system/build.prop

if [ -f $script_path/$device.json ]; then
  rm $script_path/$device.json
fi

linenr=`grep -n "ro.build.date.utc" $buildprop | cut -d':' -f1`
timestamp=`sed -n $linenr'p' < $buildprop | cut -d'=' -f2`
zip_only=`basename "$zip_name"`
md5=`md5sum "$zip_name" | cut -d' ' -f1`
size=`stat -c "%s" "$zip_name"`
version=`echo "$zip_only" | cut -d'-' -f2`
echo '{
  "response": [
    {
        "maintainer": "'$maintainer'",
        "oem": "'$oem'",
        "device": "'$devicename'",
        "filename": "'$zip_only'",
        "download": "https://sourceforge.net/projects/voltage-os/files/'$device'/'$zip_only'/download",
        "timestamp": '$timestamp',
        "md5": "'$md5'",
        "size": '$size',
        "version": "'$version'"
    }
  ]
}' >> $device.json
