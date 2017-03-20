#!/bin/bash
CONFIG=${HOME}/.config/i3/i3scrot.conf

if ! [ -f ${CONFIG} ] ; then
    echo "SCREENSHOTS_DIR=\${HOME}/Pictures/Screenshots" > ${CONFIG}
fi

source ${CONFIG}

APPNAME="i3scrot"
SSDIR=${SCREENSHOTS_DIR}
IMGNAME=Screenshot_$(date "+%Y-%m-%d_%H-%M-%S").png
SSPATH=${SSDIR}/${IMGNAME}

# Rework SSPATH if path given
if ! [ -z ${2+x} ] ; then
    SSDIR=$2
    SSPATH=${SSDIR}/${IMGNAME}
fi

SSMSG="Screeshot saved at ${SSPATH}"
VERSION=1.0
CREATOR="Kaleb Klein <klein.jae@gmail.com>"
VERSIONMSG="${APPNAME}
Version: ${VERSION}
Created By: ${CREATOR}
"
HELPMSG="This shell script allows using scrot easily anywhere.
Built for easy use in i3

USAGE: i3scrot <OPTIONS> [PATH]

Options:
--fullscreen | -f - Take fullscreen screenshot (default)
--window     | -w - Take screenshot of active window
--select     | -s - Take screenshot of selected region
--help       | -h - Display this help message

Screenshots are placed in ${SSDIR}
"

# Create screenshots dir if not exist
if ! [ -d ${SSDIR} ] ; then
    mkdir ${SSDIR}
fi

if [ -z ${NOTIFY+x} ] ; then
    NOTIFY=false
fi

ECHOMSG=true

# get cmd args
case "$1" in
    --fullscreen|-f)
        scrot ${SSPATH}
        ;;
    --window|-w)
        scrot -u ${SSPATH}
        ;;
    --select|-s)
        scrot -s ${SSPATH}
        ;;
    --help|-h|$NULL)
        echo "${HELPMSG}"
        ECHOMSG=false
        ;;
    --version|-v)
        echo "${VERSIONMSG}"
        ECHOMSG=false
        ;;
    *)
        echo "Error: \"$1\" is not a recognized option!"
        ;;
esac

# Do you wanna notify?
if ${NOTIFY} ; then
    notify-send -a ${APPNME} -u normal "${SSMSG}"
else
    if ${ECHOMSG} ; then
        echo "${SSMSG}"
    fi
fi

