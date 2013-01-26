#!/usr/bin/env bash
projectdir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$projectdir"

rm -rf buildbot-scripts
git clone git://github.com/edge-sys-design/buildbot-scripts.git
cd buildbot-scripts
bash move-into-place.sh
