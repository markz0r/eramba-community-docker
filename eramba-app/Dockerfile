FROM centos:7

MAINTAINER "Mark C" <mark@straightit.com>

RUN \
    yum -y install epel-release \
    && yum install -y httpd mod_ssl wget libXext libXrender xorg-x11-fonts-75dpi xorg-x11-fonts-Type1 \
    && yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum -y --enablerepo=remi,remi-php71 install php php-common php-cli php-gd php-intl php-json php-mbstring php-zip php-exif php-ldap php-curl php-mysql php-readline php-xml php-bz2 php-simplexml \
    && wget https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox-0.12.5-1.centos7.x86_64.rpm \
    && rpm -Uvh wkhtmltox-0.12.5-1.centos7.x86_64.rpm \
    && yum update -y \
    && yum clean all \
    && rm -vf /etc/httpd/conf.d/autoindex.conf /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/userdir.conf \
    && mkdir -p /var/www/sites

# Assumes you have downloaded eramaba community tarball to c241.tgz
# e.g.: https://downloadseramba.s3-eu-west-1.amazonaws.com/CommunityTGZ/c241.tgz
ADD c241.tgz /var/www/sites

RUN \
    chown -R apache:apache /var/www/sites/eramba_community

#COPY etc/httpd.conf /etc/httpd/conf/httpd.conf
COPY etc/25-eramba.conf  /etc/httpd/conf.d/

COPY httpd_run.sh /run.sh

EXPOSE 8080

CMD ["/run.sh"]
