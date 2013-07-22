#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

dpkg-query -l build-essential 2>&1 | grep -q 'No packages found'
if [ $? -eq 0 ]; then
  echo "Please install the build-essential package before executing this script"
  exit 1
fi

echo 
echo installing freeradius...
apt-get -y install freeradius
service freeradius stop

echo Copying Toopher Freeradius confg files
for f in ToopherAPI.pm toopher_users dictionary.toopher do_toopher_auth.pl toopher_radius_config.pm modules/files modules/perl sites-available/default
do
  cp ../freeradius/etc/raddb/$f /etc/freeradius/$f
done
for f in ToopherAPI.pm toopher_users dictionary.toopher do_toopher_auth.pl toopher_radius_config.pm
do
  chown root:freerad /etc/freeradius/$f
  chmod 644 /etc/freeradius/$f
done
echo \$INCLUDE dictionary.toopher >> /etc/freeradius/dictionary

apt-get -y install libwww-perl
apt-get -y install libcrypt-ssleay-perl
echo Installing/Updating CPAN modules.  Some modules might take several attempts.
# install needed CPAN modules.  This can still fail for unknown reasons, so
# grep for failure messages and retry for each module
CPAN_MODULES=( Net::OAuth::ConsumerRequest JSON::XS JSON Net::LDAP LWP::Protocol::https )

cpan
for module in "${CPAN_MODULES[@]}"
do
  counter=0
  mod_install_success=0
  while [ $mod_install_success -eq 0 ]
  do
    let counter=counter+1
    echo Installing $module \(attempt ${counter}\)
    ./staticperl instcpan $module 2>&1 | grep -q 'fatal error'
    mod_install_success=$?
  done
done

if [ -e /usr/lib/libperl.so.5.14.2 ]; then
  ldd /usr/lib/freeradius/rlm_perl.so | grep -q 'libperl.so.5.14 =>'
  if [ $? -eq 0 ]; then
    grep -q 'export LD_PRELOAD' /etc/init.d/freeradius
    if [ $? -ne 0 ]; then
      echo Patching /etc/init.d/freeradius to preload libperl.so.5.14.2
      sed -i "/\sstart)/ a export LD_PRELOAD=/usr/lib/libperl.so.5.14.2" /etc/init.d/freeradius
    else
      echo Looks like /etc/init.d/freeradius has already been patched. Skipping.
    fi
  fi
fi
service freeradius start
