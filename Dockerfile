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

WORKDIR /usr/local/share

RUN curl -L https://sourceforge.net/projects/lxr/files/stable/lxr-2.3.6.tgz  > lxr.tgz &&\
    tar -xvf lxr.tgz &&\
    mv lxr-2.3.6 lxr

WORKDIR /usr/local/share/lxr

ADD custom.d /usr/local/share/lxr/custom.d
ADD scripts /usr/local/share/lxr/scripts

RUN chmod +x scripts/entrypoint.sh
RUN cp custom.d/lxr.conf .

RUN cp custom.d/apache-lxrserver.conf /etc/apache2/sites-enabled/

ENTRYPOINT [ "/usr/local/share/lxr/scripts/entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
