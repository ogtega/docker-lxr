#!/bin/sh
/etc/init.d/apache2 start
while !(mysqladmin -uroot ping); do sleep 3; echo "waiting for mysql ..."; done
/usr/local/share/lxr/custom.d/initdb.sh
./genxref --url=http://localhost/ --allversions
exec "$@"