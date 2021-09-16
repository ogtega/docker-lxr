FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
    apt-get install -y curl &&\
    apt-get install -y build-essential &&\
    apt-get install -y perl libperl-dev &&\
	apt-get install -y git &&\
    apt-get install -y exuberant-ctags &&\
    apt-get install -y cpanminus &&\
    apt-get install -y glimpse &&\
    apt-get install -y mariadb-client libmariadb-dev &&\
    apt-get install -y libapr1-dev libaprutil1-dev libpcre3-dev # Apache build reqs

RUN cpanm DBI &&\
    cpanm File::MMagic &&\
	cpanm DBD::MariaDB

WORKDIR /opt

RUN curl -L https://dlcdn.apache.org//httpd/httpd-2.4.49.tar.gz > apache2.tar.gz &&\
    tar -xvf apache2.tar.gz &&\
    mv httpd-2.4.49 httpd

WORKDIR /opt/httpd

RUN ./configure --prefix=/etc/httpd --enable-modules=all --enable-cgi
RUN make && make install

WORKDIR /opt

RUN curl -L https://dlcdn.apache.org/perl/mod_perl-2.0.11.tar.gz > modperl.tar.gz &&\
    tar -xvf modperl.tar.gz &&\
    mv mod_perl-2.0.11 modperl

WORKDIR /opt/modperl

RUN perl Makefile.PL MP_AP_PREFIX=/etc/httpd
RUN make && make install

WORKDIR /etc/httpd/cgi-bin

RUN curl -L https://sourceforge.net/projects/lxr/files/stable/lxr-2.3.6.tgz  > lxr.tgz &&\
    tar -xvf lxr.tgz &&\
    mv lxr-2.3.6 lxr &&\
    rm lxr.tgz

WORKDIR /etc/httpd/cgi-bin/lxr

ADD custom.d /etc/httpd/cgi-bin/lxr/custom.d
ADD scripts /etc/httpd/cgi-bin/lxr/scripts

RUN chmod +x scripts/entrypoint.sh
RUN cp custom.d/lxr.conf .

RUN echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf
RUN echo "LoadModule cgi_module modules/mod_cgi.so" >> /etc/httpd/conf/httpd.conf
RUN echo "LoadModule perl_module modules/mod_perl.so" >> /etc/httpd/conf/httpd.conf
RUN echo "Include conf/apache-lxrserver.conf" >> /etc/httpd/conf/httpd.conf
RUN cp custom.d/apache-lxrserver.conf /etc/httpd/conf

ENTRYPOINT [ "/etc/httpd/cgi-bin/lxr/scripts/entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
