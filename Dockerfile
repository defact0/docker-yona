FROM centos:7

#
# 필요 프로그램 설치
#

RUN yum install -y sudo tar wget unzip deltarpm && \
 localedef -f UTF-8 -i ko_KR ko_KR.utf8 && ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime


 
#
# MARIA DB 설치
#

ENV MYSQL_ROOT_PASSWORD=1q2w3e

RUN echo "# MariaDB 10.3 CentOS repository list - created 2020-06-08 14:21 UTC" > /etc/yum.repos.d/MariaDB.repo && \
    echo "# http://downloads.mariadb.org/mariadb/repositories/" >> /etc/yum.repos.d/MariaDB.repo && \
    echo "[mariadb]" >> /etc/yum.repos.d/MariaDB.repo && \
    echo "name = MariaDB" >> /etc/yum.repos.d/MariaDB.repo && \
    echo "baseurl = http://yum.mariadb.org/10.3/centos7-amd64" >> /etc/yum.repos.d/MariaDB.repo && \
    echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/MariaDB.repo && \
    echo "gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo && \
    yum -y install MariaDB-server MariaDB-client
	
RUN systemctl enable mariadb && \
    cp /etc/my.cnf.d/server.cnf /etc/my.cnf.d/server.cnf_org && \
	sed -i'' -r -e "/\[mysqld\]/a\lower_case_table_names=1" /etc/my.cnf.d/server.cnf
	
ADD ["/config/yona.sql", "/tmp/yona.sql"]
RUN /etc/init.d/mysql start && \
    mysqladmin -u root -p password $MYSQL_ROOT_PASSWORD
RUN /etc/init.d/mysql start && \
    mysql -u root -p$MYSQL_ROOT_PASSWORD  < /tmp/yona.sql
RUN rm -rf /tmp/yona.sql

EXPOSE 3306


#
# JDK 설치
#

RUN rpm --import http://repos.azulsystems.com/RPM-GPG-KEY-azulsystems && \
    curl -o /etc/yum.repos.d/zulu.repo http://repos.azulsystems.com/rhel/zulu.repo && \
    yum -q -y update && \
    yum -q -y upgrade && \
    yum -q -y install zulu-8-8.46.0.19 && \
    yum clean all && \
    rm -rf /var/cache/yum

ENV JAVA_HOME=/usr/lib/jvm/zulu-8


#
# Yona 설치
#

COPY ./app/yona-1.14.0-bin.zip /
RUN unzip /yona-1.14.0-bin.zip  && \
    rm -rf /yona-1.14.0-bin.zip && \
	mv /yona-1.14.0 /usr/yona

COPY ./sh/fn_yonastart.sh /usr/yona/bin/
COPY ./sh/fn_yonastop.sh /usr/yona/bin/
RUN echo "alias yonastart='sh /usr/yona/bin/fn_yonastart.sh'" >> /root/.bashrc
RUN echo "alias yonastop='sh /usr/yona/bin/fn_yonastop.sh'" >> /root/.bashrc

EXPOSE 9000

#
# ENTRYPOINT 설정
#

COPY ./config/yona.service /etc/systemd/system
RUN chmod 755 /etc/systemd/system/yona.service && \
	systemctl enable yona.service

ENTRYPOINT ["/sbin/init", "systemctl start yona"]