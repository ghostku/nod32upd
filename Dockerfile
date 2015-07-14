# Version: 0.0.1
FROM ubuntu:14.04
MAINTAINER GhostKU <ghostku@ghostku.com>
#Install dependencies
RUN export DEBIAN_FRONTEND=noninteractive;\
	apt-get update;\
	apt-get install -y wget unzip curl unrar-free apache2 apache2-utils supervisor && apt-get clean

ENV NOD_FOLDER /home/nod32

#Install script
RUN wget -N https://github.com/tarampampam/nod32-update-mirror/archive/master.zip;\
	unzip -o master.zip;\
	mv -f ./nod32-update-mirror-master/nod32upd $NOD_FOLDER;\
	mv -f ./nod32-update-mirror-master/webface $NOD_FOLDER/mirror;\
	sed -i -e 's/^pathToSaveBase=.*/pathToSaveBase=\"\/var\/www\/html\/\";/g' $NOD_FOLDER/settings.cfg;\
	chmod +x $NOD_FOLDER/*.sh

# Add password protection to .htaccess and Enable it
RUN echo 'AuthType Basic \n AuthName "NOD32 Updater. Please login"\n AuthUserFile "'$NOD_FOLDER'/.htpasswd" \n Require valid-user' >> $NOD_FOLDER/mirror/.htaccess
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/apache2/apache2.conf

# Add crontab file in the cron directory and enable cron
COPY crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
RUN touch /var/log/cron.log

ENV NOD_VERSIONS v4 v5 v6 v7 v8
ENV NOD_LANGS 1033 1049 1058
ENV NOD_LOG nod32
ENV NOD_PWD nod32

#Some apache2 fixes
RUN mkdir /var/lock/apache2 /var/run/apache2

#Supervisord settings
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80
# Run the command on container startup
CMD  sed -i -e "s/^checkSubdirsList=.*$/checkSubdirsList=($NOD_VERSIONS);/g" -e "s/^updLanguages=.*/updLanguages=($NOD_LANGS);/g" $NOD_FOLDER/settings.cfg && \
cp $NOD_FOLDER/mirror/. /var/www/html/ -r && \
htpasswd -b -c $NOD_FOLDER/.htpasswd $NOD_LOG $NOD_PWD && \
/usr/bin/supervisord
#CMD /bin/bash