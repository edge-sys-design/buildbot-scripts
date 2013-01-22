#!/usr/bin/env bash
projectdir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$projectdir"
rm -rf Frequency
git clone git://github.com/edge-sys-design/Frequency.git
cd Frequency

export ANDROID_SDK_HOME='/home/ricky/buildbot/android-sdk-linux'
export _JAVA_OPTIONS='-Xmx256m -Xms128m'

sbt publish
