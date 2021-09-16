#!/bin/sh
while !(mysqladmin -uroot ping); do sleep 3; echo "waiting for mysql ..."; done
/etc/httpd/cgi-bin/lxr/custom.d/initdb.sh
./genxref --url=http://localhost/cgi-bin/lxr --allversions
/etc/httpd/bin/apachectl -k start
exec "$@"