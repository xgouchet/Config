# Android path variables
export ANDROID_SDK=/opt/android/sdk
export ANDROID_HOME=/opt/android/sdk

export PATH=${PATH}:$ANDROID_SDK/tools
export PATH=${PATH}:$ANDROID_SDK/tools/bin
export PATH=${PATH}:$ANDROID_SDK/platform-tools

export SERIAL_HONOR9=7BKDU17727001808
export SERIAL_GEAR=R3AF600DQLK
export SERIAL_NEXUS7=0a608ee4

function adb_set_serial() {
    export ANDROID_SERIAL=$1
}

function adb_reset_serial() {
    unset ANDROID_SERIAL
}

# Usage : adb_clear_storage com.package.name
function adb_clear_storage () {
    adb shell pm clear $1
}

# Usage : adb_pull_db_pre_lollipop com.package.name file.db
function adb_pull_db_pre_lollipop () {

    if [[ -z "$1" ]]; then
        echo "Usage : adb_pull_db_pre_lollipop com.package.name file.db"
    else
        adb shell "run-as $1 chmod 666 /data/data/$1/databases/$2"
        adb pull /data/data/$1/databases/$2 .
        adb shell "run-as $1 chmod 600 /data/data/$1/databases/$2"
    fi
}

# Usage : adb_pull_db com.package.name file.db
function adb_pull_db () {

    if [[ -z "$1" ]]; then
        echo "Usage : adb_pull_db com.package.name file.db"
    else
        adb exec-out "run-as $1 cat /data/data/$1/databases/$2" > $2
    fi

}

# Usage : adb_delete_db com.package.name file.db
function adb_delete_db () {

    if [[ -z "$1" ]]; then
        echo "Usage : adb_delete_db com.package.name file.db"
    else
        adb exec-out "run-as $1 rm /data/data/$1/databases/$2"
    fi

}

# Usage : adb_print some text "with quotes" too
function adb_print() {
    local needsSpace=0
    for arg in "$@"
    do
        for word in "$arg"
        do
            if [ "$needsSpace" -ne "0" ]; then
                adb shell input keyevent 62
            fi
            adb shell input text $word
            needsSpace=1
        done
    done
}

# Usage : adb_println some text "with quotes" too
function adb_println() {
    adb_print "$@"
    adb shell input keyevent 66
}

# Usage : adb_am_view url [adb flags]
function adb_am_view() {
    adb shell am start -a "android.intent.action.VIEW" -d "$@"
}


# Usage : adb_grant_permission packagename permission
function adb_grant_permission() {
    adb shell pm grant $1 $2
}

function adb_show_app_info() {
    adb shell am start -a "android.settings.APPLICATION_DETAILS_SETTINGS" -d "package:$@"
}

# usage export_svg source.svg output.png sizedp
function export_svg() {

    mkdir -p "drawable-ldpi"
    size=$(($3 * 3 / 4))
    inkscape -z -e "drawable-ldpi/$2" -w $size -h $size "$1"
    mkdir -p "drawable-mdpi"
    size=$(($3))
    inkscape -z -e "drawable-mdpi/$2" -w $size -h $size "$1"
    mkdir -p "drawable-hdpi"
    size=$(($3 * 3 / 2))
    inkscape -z -e "drawable-hdpi/$2" -w $size -h $size "$1"
    mkdir -p "drawable-xhdpi"
    size=$(($3 * 2))
    inkscape -z -e "drawable-xhdpi/$2" -w $size -h $size "$1"
    mkdir -p "drawable-xxhdpi"
    size=$(($3 * 3))
    inkscape -z -e "drawable-xxhdpi/$2" -w $size -h $size "$1"
    mkdir -p "drawable-xxxhdpi"
    size=$(($3 * 4))
    inkscape -z -e "drawable-xxxhdpi/$2" -w $size -h $size "$1"
}

# usage adb_tap fullresource_id
# eg : adb_tap com.sample.app:id/button 
function adb_tap() {
    adb pull $(adb shell uiautomator dump | grep -oP '[^ ]+.xml') /tmp/view.xml
    bounds=$(xmlstarlet sel -t -v "//*/node[@resource-id='$1']/@bounds" /tmp/view.xml)
    echo $bounds | grep -o "[0-9]*" > /tmp/bounds

    if [ -z "$bounds" ]; then
        echo "View with id $1 could not be found"
        return
    fi

    echo "bounds = $bounds"

    left=$(cat /tmp/bounds | head -1)
    top=$(cat /tmp/bounds | head -2 | tail -1)
    right=$(cat /tmp/bounds | head -3 | tail -1)
    bottom=$(cat /tmp/bounds | head -4 | tail -1)

    x=$(( ($left + $right) / 2))
    y=$(( ($top + $bottom) / 2))
    echo "view center locate at $x,$y / $bounds"
    adb shell input tap $x $y
}

function adb_screenshot() {
    adb shell screencap -p /sdcard/screen.png
    adb pull /sdcard/screen.png
    adb shell rm /sdcard/screen.png
}
