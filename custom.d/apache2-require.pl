#!/usr/bin/env perl -w
# Apache mod_perl additional configuration file
#
#	If configured manually, it could be worth to use relative
#	file paths so that this file is location independent.
#	Relative file paths are here relative to LXR root directory.

@INC=	( @INC
		, "/etc/httpd/cgi-bin/lxr"		# <- LXR root directory
		, "/etc/httpd/cgi-bin/lxr/lib"	# <- LXR library directory
		);

1;
