FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
    apt-get install -y curl &&\
    apt-get install -y build-essential &&\
    apt-get install -y perl &&\
	apt-get install -y git &&\
    apt-get install -y expect &&\
    apt-get install -y exuberant-ctags &&\
    apt-get install -y cpanminus &&\
    apt-get install -y glimpse &&\
    apt-get install -y mariadb-client &&\
    apt-get install -y libmariadb-dev &&\
    apt-get install -y apache2 &&\
    apt-get install -y libapache2-mod-perl2-dev

RUN cpanm DBI &&\
    cpanm File::MMagic &&\
	cpanm DBD::MariaDB

WORKDIR /srv

RUN curl -L https://sourceforge.net/projects/lxr/files/stable/lxr-2.3.6.tgz  > lxr.tgz &&\
    tar -xvf lxr.tgz &&\
    mv lxr-2.3.6 lxr &&\
    rm lxr.tgz

WORKDIR /srv/lxr

ADD custom.d /srv/lxr/custom.d
ADD scripts /srv/lxr/scripts

RUN chmod +x scripts/entrypoint.sh
RUN cp custom.d/lxr.conf .

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN cp custom.d/apache-lxrserver.conf /etc/apache2/sites-available/000-default.conf

ENTRYPOINT [ "/srv/lxr/scripts/entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
