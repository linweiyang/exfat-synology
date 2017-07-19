#!/bin/sh

USB=$(echo "$@" | grep "volumeUSB")
#usb types
if [ -n "$USB" ]; then
    #exfat partition
    if [ "$2" == "exfat" ]; then
        m=$(/bin/mount.bin | grep "$5")
        if [ -z "$m" ]; then
            n="$6"
            n=${n#*/volumeUSB}
            n=${n%%/usbshare}
            /bin/mount.exfat-fuse "$5" "/volume1/usbexfat/usbshare$n" -o nonempty
            if [ -f /bin/autosync.sh ]; then
                /bin/autosync.sh "$5" "/volume1/usbexfat/usbshare$n" &
            fi
        fi
    #fat32 partition
    elif [ "$2" == "vfat" ]; then
        /bin/mount.bin "$@" &
        if [ -f /bin/autosync.sh ]; then
            /bin/autosync.sh "$5" "$6" &
        fi
    #others partition
    else
        /bin/mount.bin "$@"      
    fi
#other types
else
    /bin/mount.bin "$@"
fi
