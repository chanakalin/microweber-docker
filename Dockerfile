#Use CentOS as the base
FROM centos:centos8.3.2011

#HTTP port expose
EXPOSE 80

#Package installation
#Install remi
RUN dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
#Switch the PHP version to 7.4
RUN dnf -y module install php:remi-7.4
#Install PHP, PHP libs and nginx
RUN dnf -y install php php-mbstring php-xml php-xmlrpc php-bcmath php-fpm php-gd php-imap php-pgsql php-mysqlnd php-mysql nginx wget unzip

#Configure nginx
RUN rm -rf /etc/nginx/nginx.conf
ADD --chown=nginx:nginx nginx.conf /etc/nginx/nginx.conf
#Configure php-fpm
RUN rm -rf /etc/php-fpm.conf
ADD --chown=root:root php-fpm.conf /etc/php-fpm.conf

#Service disable
RUN systemctl disable kdump
#Service enable
RUN systemctl enable php-fpm
RUN systemctl enable nginx

#Download and create microweber installation
RUN mkdir /microweber
RUN wget https://microweber.org/download.php -O /microweber.zip
#Download the latest
RUN unzip -d /microweber -x /microweber.zip
#Copy from existing zip
#ADD --chown=root:root microweber.zip /microweber.zip
RUN chown -R nginx:nginx /microweber
RUN chmod -R 0775 /microweber/storage/ /microweber/userfiles/

#Install microweber
ADD --chown=root:root installMicroweber.sh /installMicroweber.sh
RUN chmod +x /installMicroweber.sh
RUN /installMicroweber.sh

#Post installation
RUN chmod -R 0775 /microweber/storage/database.sqlite
RUN chown -R nginx:nginx /microweber/storage/database.sqlite


#Command on startup
CMD ["setenforce","0"]
CMD ["/sbin/init"]

###########################################################################################################################################################
#Build
#docker build -t microweber ./
#RUN
#docker run -it --privileged=true --tmpfs /tmp --tmpfs /run -p 0.0.0.0:8080:80 microweber
#Access bash
#docker ps
#docker exec -it <CONTAINER ID> /bin/bash
