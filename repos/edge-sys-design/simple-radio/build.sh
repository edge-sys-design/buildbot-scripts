#!/usr/bin/env bash
projectdir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$projectdir"
rm -rf simple-radio
git clone git://github.com/edge-sys-design/simple-radio.git

rm -rf ~/.ivy2/cache/com.edgesysdesign*

cd simple-radio

HEAD=$(git log -n1 --pretty=%h)
RESULT_PATH="$HOME/buildbot/edge-sys-design-simple-radio/result"
RESULT_DIR="$RESULT_PATH/$(date '+%Y-%m-%d')/$HEAD"

sed -i "s/<string name=\"version\">.*<\/string>/<string name=\"version\">$HEAD<\/string>/" src/main/res/values/development.xml
sed -i "s/<string name=\"development_build\">.*<\/string>/<string name=\"development_build\">true<\/string>/" src/main/res/values/development.xml
mkdir -pv $RESULT_DIR

export ANDROID_SDK_HOME='/home/ricky/buildbot/android-sdk-linux'
export _JAVA_OPTIONS='-Xmx256m -Xms128m'
sbt android:package-debug | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" > $RESULT_DIR/build.log

if [ $? -eq 0 ]; then
  # Build was successful
  mv -v target/simpleradio*.apk $RESULT_DIR/simpleradio-$HEAD.apk
  echo -n "$(git log -1 --oneline --color=never)" > $RESULT_DIR/commit-info.txt
  echo -n "$HEAD" > $RESULT_DIR/commit-sha.txt
  rm -f $RESULT_PATH/CURRENT-HEAD
  ln -svf "$(date '+%Y-%m-%d')/$HEAD" $RESULT_PATH/CURRENT-HEAD
else
  # Nope.
  echo "Exit code was $?"
  touch $RESULT_DIR/FAILED
fi

cd $RESULT_DIR/../../../

rsync -avzre 'ssh -i /home/ricky/buildbot/buildsys_id_rsa' \
  --partial --progress ./result/ \
  buildsys@phabricator.edgesysdesign.com:web/simple-radio/
