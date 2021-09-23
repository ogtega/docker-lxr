#!/bin/sh
while !(mysqladmin -uroot ping); do sleep 3; echo "waiting for mysql ..."; done
./custom.d/db-scripts.d/m:lxr:lxr_.sh
./genxref --url=http://localhost --allversions
/etc/init.d/lighttpd start
exec "$@"