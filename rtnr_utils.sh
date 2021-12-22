#!/bin/bash

USAGE_ACTIONS=$(cat <<-END
!!! Make sure RTNR numids are detected before following steps !!!

Select your action for RTNR:
    1: Enable RTNR Processing
    2: Disable RTNR Processing
END
)

read -p "This script is used to perform operations on RTNR running in sof. Continue (y/N)?  " VAR_UPDATE
if [[ "$VAR_UPDATE" == "y" ]]; then
    numid_rtnr_bytes=$(amixer -Dhw:0 controls | grep "rtnr_bytes" | sed -En 's/^numid=([0-9]+),(.*)/\1/p')
    numid_rtnr_preset_bytes=$(amixer -Dhw:0 controls | grep "rtnr_preset_bytes" | sed -En 's/^numid=([0-9]+),(.*)/\1/p')
    numid_rtnr_model_bytes=$(amixer -Dhw:0 controls | grep "rtnr_model_bytes" | sed -En 's/^numid=([0-9]+),(.*)/\1/p')

    echo ""
    echo "RTNR numid:" "$numid_rtnr_bytes"
    echo "RTNR Preset numid:" "$numid_rtnr_preset_bytes"
    echo "RTNR Model numid:" "$numid_rtnr_model_bytes"
    echo ""

    echo "$USAGE_ACTIONS"    
    read VAR_ACTION

    if [[ "$VAR_ACTION" == "1" ]]; then
        echo "[Enable RTNR Processing]"
        ./sof-ctl -Dhw:0 -n $numid_rtnr_bytes -s ./rtnr_on.txt > /dev/null
        echo "Done."
    elif [[ "$VAR_ACTION" == "2" ]]; then
        echo "[Disable RTNR Processing]"
        ./sof-ctl -Dhw:0 -n $numid_rtnr_bytes -s ./rtnr_off.txt > /dev/null
        echo "Done."
    fi
else
    echo "Have a nice day. Goodbye."
fi
