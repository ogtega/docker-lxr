FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
    apt-get install -y build-essential &&\
    apt-get install -y cpanminus &&\
    apt-get install -y curl &&\
    apt-get install -y exuberant-ctags &&\
	apt-get install -y git &&\
    apt-get install -y glimpse &&\
    apt-get install -y libmariadb-dev &&\
    apt-get install -y libperl-dev &&\
    apt-get install -y lighttpd &&\
    apt-get install -y mariadb-client &&\
    apt-get install -y perl

RUN cpanm DBI &&\
    cpanm DBD::MariaDB &&\
    cpanm File::MMagic

COPY lxr /opt/lxr/

WORKDIR /opt/lxr

ADD entrypoint.sh /opt/entrypoint.sh
ADD custom/lxr.conf /opt/lxr/lxr.conf
ADD custom/lxr.ctxt /opt/lxr/custom.d/lxr.ctxt
ADD custom/m:lxr:lxr_.sh /opt/lxr/custom.d/db-scripts.d/m:lxr:lxr_.sh
ADD custom/lighttpd-lxrserver.conf /etc/lighttpd/conf-enabled/lighttpd-lxrserver.conf

RUN chmod +x /opt/entrypoint.sh
RUN ln -s /etc/lighttpd/conf-available/10-cgi.conf /etc/lighttpd/conf-enabled/10-cgi.conf

ENTRYPOINT [ "/opt/entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
