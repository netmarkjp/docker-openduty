FROM ubuntu:14.04
MAINTAINER Toshiaki Baba <toshiaki@netmark.jp>
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install nginx supervisor
#RUN apt-get -y install mysql-server-5.6
RUN apt-get -y install git python-pip python-dev build-essential g++ libbz2-dev libncurses5-dev libreadline-dev libsqlite3-dev libssl-dev libxml2-dev libxslt-dev make zlib1g-dev
RUN git clone https://github.com/ustream/openduty.git /opt/openduty
RUN cd /opt/openduty && pip install -r requirements.txt
RUN cd /opt/openduty && pip install gunicorn
RUN cd /opt/openduty && export DJANGO_SETTINGS_MODULE=openduty.settings_dev && python manage.py syncdb
RUN cd /opt/openduty && export DJANGO_SETTINGS_MODULE=openduty.settings_dev && python manage.py migrate

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 8000 3306
CMD ["/usr/bin/supervisord"]
