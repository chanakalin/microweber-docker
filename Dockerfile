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
RUN systemctl disable dnf-makecache.timer
#Service enable
RUN systemctl enable php-fpm
RUN systemctl enable nginx

#Download and create microweber installation
RUN mkdir /microweber
RUN wget https://microweber.org/download.php -O /microweber.zip
#Copy from existing zip
#ADD --chown=root:root microweber.zip /microweber.zip

#microweber installer
ADD --chown=root:root installMicroweber.sh /installMicroweber.sh
RUN chmod +x /installMicroweber.sh

#Volumes
VOLUME ["/microweber/storage/","/microweber/userfiles/","/microweber/config"]

#environment vairables
#ENV adminEmail=admin@example.com
#ENV adminUsername=admin
#ENV adminPassword=admin
#ENV dbEngine=sqlite

#Command on startup
CMD ["/installMicroweber.sh","/sbin/init"]
