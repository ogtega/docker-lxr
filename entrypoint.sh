#!/bin/sh
while !(mysqladmin -uroot ping); do sleep 3; echo "waiting for mysql ..."; done
./custom.d/db-scripts.d/m:lxr:lxr_.sh
chmod -R 777 /opt/src
/etc/init.d/lighttpd start
./genxref --url=http://localhost --version=main
exec "$@"