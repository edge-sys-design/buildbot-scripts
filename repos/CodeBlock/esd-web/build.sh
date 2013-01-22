#!/usr/bin/env bash
projectdir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$projectdir"
rm -rf esd-web
ssh-agent sh -c '(ssh-add '\''/home/ricky/buildbot/buildsys_id_rsa'\'' && git clone --origin origin '\''ssh://git@github.com/CodeBlock/esd-web.git'\'')'
cd esd-web
mv production.yml.dist production.yml
stasis

rsync -avzre 'ssh -i /home/ricky/buildbot/buildsys_id_rsa' \
  --delete --partial --progress ./public/ \
  buildsys@phabricator.edgesysdesign.com:web/esd-web-head/
