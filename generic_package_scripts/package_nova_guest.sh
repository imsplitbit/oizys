# Assume the first parameter is the REVNO for the package
cd ~
rm -fr guest
sudo rm -fr /home/vagrant/build
mkdir -p guest
cd guest
git clone git://github.com/rackspace/reddwarf.git src
# git clone git://github.com/hub-cap/nova-temp-package-files.git packagefiles
cd src/
GIT_REVISION=`git --git-dir=.git rev-parse HEAD`
cd reddwarf-guest/
sudo sh vagrant/initialize.sh
mv debian debian.bak
cp -R /vagrant/nova_guest_diablo_scripts debian
#Somehow change the revno
sed -i.bak "s/\(nova-guest ([0-9\.-]\+\)/\1-$1\.gbpe6a4b0/g" debian/changelog
sed -i.bak "s/Description: \(.*\)/Description: \1 - $GIT_REVISION/g" debian/control
DEB_BUILD_OPTIONS=nocheck,nodocs dpkg-buildpackage -rfakeroot -b -uc -us
cd ..
tar czvf guest_debs.tgz nova-guest*.deb
# Now we have our files ~/nova/guest_debs.tgz
cd ~