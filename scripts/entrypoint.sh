#!/bin/sh
chmod -R 755 /srv
chown -R root:www-data /srv
while !(mysqladmin -uroot ping); do sleep 3; echo "waiting for mysql ..."; done
/srv/lxr/custom.d/initdb.sh
./genxref --url=http://localhost/lxr --allversions
a2enmod cgi
service apache2 restart
exec "$@"