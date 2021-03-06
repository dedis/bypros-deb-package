#! /usr/bin/env bash
set -xe

# cleanup previous installations
rm -rf deb
mkdir deb

cp -a pkg/lib deb
cp -a pkg/opt deb
cp -a pkg/etc deb
cp -a pkg/var deb

mv app/bypros-deb deb/opt/dedis/bypros/bin/ # binary created by C.I.
mv pre-start.sh   deb/opt/dedis/bypros/bin/

# adjust permissions
find deb ! -perm -a+r -exec chmod a+r {} \;

fpm \
    --force -t deb -a all -s dir -C deb -n dedis-bypros -v $(cat VERSION)\
    --deb-user bypros \
    --deb-group bypros \
    --before-install pkg/before-install.sh \
    --after-install pkg/after-install.sh \
    --before-remove pkg/before-remove.sh \
    --after-remove pkg/after-remove.sh \
    --url https://github.com/dedis/bypros-deb-package.git \
    --description 'Byzcoin proxy package' \
    --package dedis-bypros-v$(cat VERSION).deb \
    .

# cleanup
rm -rf ./deb
