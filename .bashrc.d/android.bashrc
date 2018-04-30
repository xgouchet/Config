# Android path variables
export ANDROID_SDK=/opt/android/sdk
export ANDROID_HOME=/opt/android/sdk

export PATH=${PATH}:$ANDROID_SDK/tools
export PATH=${PATH}:$ANDROID_SDK/tools/bin
export PATH=${PATH}:$ANDROID_SDK/platform-tools

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
