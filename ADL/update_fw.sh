#!/bin/bash

USAGE=$(cat <<-END
Select firmware to update:
    1: sof-adl with RTNR
END
)

read -p "Do you want to update sof firmare? (y/N) " VAR1
if [[ "$VAR1" == "y" ]]; then

echo "yes"
echo "$USAGE"    
read VAR2

if [[ "$VAR2" == "1" ]];
then
    echo "Downloading files for sof-adl with RTNR ..."
    
    curl -L https://mingjentai.github.io/rtnr/ADL/sof-adl.ri --output sof-adl.ri
    curl -L https://mingjentai.github.io/rtnr/ADL/sof-adl.ri.md5 --output sof-adl.ri.md5
    curl -L https://mingjentai.github.io/rtnr/ADL/sof-adl.ldc --output sof-adl.ldc
    curl -L https://mingjentai.github.io/rtnr/ADL/sof-adl.ldc.md5 --output sof-adl.ldc.md5
    curl -L https://mingjentai.github.io/rtnr/ADL/sof-adl-max98390-rt5682-rtnr.tplg --output sof-adl-max98390-rt5682-rtnr.tplg
    curl -L https://mingjentai.github.io/rtnr/ADL/sof-adl-max98390-rt5682-rtnr.tplg.md5 --output sof-adl-max98390-rt5682-rtnr.tplg.md5
    
    correct_md5_ri=$(cat ./sof-adl.ri.md5)
    correct_md5_ldc=$(cat ./sof-adl.ldc.md5)
    correct_md5_tplg=$(cat ./sof-adl-max98390-rt5682-rtnr.tplg.md5)
    
    echo "Verifying..."
    md5_ri=`md5sum ./sof-adl.ri | awk '{ print $1 }'`
    md5_ldc=`md5sum ./sof-adl.ldc | awk '{ print $1 }'`
    md5_tplg=`md5sum ./sof-adl-max98390-rt5682-rtnr.tplg | awk '{ print $1 }'`
    echo "MD5(ri):" "$md5_ri"
    echo "MD5(ldc):" "$md5_ldc"
    echo "MD5(tplg):" "$md5_tplg"
    if [[ "$md5_ri" == "$correct_md5_ri" && "$md5_ldc" == "$correct_md5_ldc" && "$md5_tplg" == "$correct_md5_tplg" ]];
    then
        echo "MD5 match."
        echo "Updating to system..."
        cp ./sof-adl.ri /lib/firmware/intel/sof/community/sof-adl.ri
        cp ./sof-adl.ldc /lib/firmware/intel/sof/community/sof-adl.ldc
        cp ./sof-adl-max98390-rt5682-rtnr.tplg /lib/firmware/intel/sof-tplg/sof-adl-max98390-rt5682.tplg
        read -p "Done. Reboot now? (y/N) " VAR1
        if [[ "$VAR1" == "y" ]]; then
            echo "Rebooting system..."
            reboot
        else
            echo "Please reboot system to take effect."
        fi
    else
        echo "MD5 mismatch. Abort."
    fi
else
    echo "Invalid option. Abort."
fi

else

echo "Bye bye!"

fi
