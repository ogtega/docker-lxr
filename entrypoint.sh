#!/bin/sh
while !(mysqladmin -uroot ping); do sleep 3; echo "waiting for mysql ..."; done
./custom.d/initdb.sh
/etc/init.d/lighttpd start
./genxref --url=http://localhost --allversions
exec "$@"