#!/bin/bash
set -euox pipefail

RPM_SPECFILE=rpmbuild/SPECS/osbuild-composer.spec
mkdir -p rpmbuild/SOURCES/ rpmbuild/SPECS/

pushd coreos-installer-dracut
COMMIT=$(git rev-parse HEAD)
SHORT_COMMIT=$(git rev-parse --short HEAD)
git archive "--prefix=coreos-installer-dracut-${COMMIT}/" --format=tar.gz HEAD > "../rpmbuild/SOURCES/coreos-installer-dracut-${COMMIT}.tar.gz"
popd

git clone https://gitlab.com/redhat/centos-stream/rpms/rust-coreos-installer.git rust-coreos-installer

cp rust-coreos-installer/enable-rdcore.patch rpmbuild/SOURCES/

TMP_RELEASE="1.$(date +'%Y%m%d')git${SHORT_COMMIT}"
sed "s/{dracutshortcommit}.tar.gz/{dracutcommit}.tar.gz/; s/1%{/$TMP_RELEASE%{/; s/global dracutcommit.*/global dracutcommit $COMMIT/" rust-coreos-installer/rust-coreos-installer.spec > $RPM_SPECFILE

# Download coreos-installer source tar package
spectool -g -s 0 -C rpmbuild/SOURCES $RPM_SPECFILE
spectool -g -s 1 -C rpmbuild/SOURCES $RPM_SPECFILE

# Build coreos-installer and coreos-installer-dracut RPMs
rpmbuild -bb --define "_topdir $(pwd)/rpmbuild" $RPM_SPECFILE

sudo mkdir -p /var/www/html/source
sudo cp ./osbuild/rpmbuild/RPMS/noarch/* /var/www/html/source/ 2>/dev/null || :
sudo cp ./osbuild-composer/rpmbuild/RPMS/x86_64/* /var/www/html/source/ 2>/dev/null || :
sudo cp ./rpmbuild/RPMS/x86_64/* /var/www/html/source/ 2>/dev/null || :
sudo createrepo_c /var/www/html/source
sudo ls -al /var/www/html/source

# Create local repo to install osbuild and osbuild-composer with local built version
sudo tee "/etc/yum.repos.d/source.repo" > /dev/null << EOF
[source]
name = source
baseurl = file:///var/www/html/source/
enabled = 1
gpgcheck = 0
priority = 5
EOF

# Check local repo working or not
sudo dnf info osbuild osbuild-composer coreos-installer-dracut
