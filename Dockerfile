FROM debian:buster
MAINTAINER Niboo SPRL <info@niboo.com>

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get update --fix-missing \
        && apt-get install -y --no-install-recommends \
            build-essential \
            ca-certificates \
            curl \
            lcov \
            ldap-utils \
            libssl1.1 \
            libssl-dev \
            libffi-dev \
            libldap2-dev \
            libxml2-dev \
            libxslt1-dev \
            libsasl2-dev \
            libpq-dev \
            node-less \
            postgresql \
            postgresql-contrib \
            python3 \
            python2.7-dev \
            python3-dateutil \
            python3-dev \
            python3-lxml \
            python3-pip \
            python3-psutil \
            python3-psycopg2 \
            python3-renderpm \
            python3-setuptools \
            python3-watchdog \
            # slapd \
            valgrind \
            xz-utils \
            zlib1g \
            zlib1g-dev \
            git \
        && curl -o wkhtmltox.deb -SL https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb \
        && apt install -y ./wkhtmltox.deb \
        && rm wkhtmltox.deb \
        && pip3 install werkzeug==0.11.11 \
        Babel==2.3.4 \
        decorator==4.0.10 \
        docutils==0.12 \
        feedparser==5.2.1 \
        gevent==1.4.0 \
        greenlet==0.4.15 \
        html2text==2016.9.19 \
        Jinja2==2.8 \
        Mako==1.0.4 \
        MarkupSafe==0.23 \
        mock==2.0.0 \
        num2words==0.5.4 \
        ofxparse==0.16 \
        passlib==1.6.5 \
        Pillow==7.0.0 \
        psutil==4.3.1 \
        psycogreen==1.0 \
        psycopg2==2.7.1 \
        pydot==1.2.3 \
        pyldap==3.0.0.post1 \
        pyparsing==2.1.10 \
        PyPDF2==1.26.0 \
        pyserial==3.1.1 \
        python-dateutil==2.5.3 \
        python-openid==2.2.5 \
        pytz==2016.7 \
        pyusb==1.0.0 \
        PyYAML==3.12 \
        qrcode==5.3 \
        reportlab==3.3.0 \
        requests==2.11.1 \
        six==1.10.0 \
        suds-jurko==0.6 \
        vatnumber==1.2 \
        vobject==0.9.3 \
        Werkzeug==0.11.11 \
        XlsxWriter==0.9.3 \
        xlwt==1.3 \
        xlrd==1.0.0

# Install Odoo
ENV ODOO_ORIGINAL_TAG "v11.0.1.0"
RUN set -x; \
        mkdir -p /opt/local/odoo \
        && cd /opt/local/odoo \
        && git clone -b ${ODOO_ORIGINAL_TAG} --single-branch --depth 1 https://github.com/Niboo/odoo.git odoo \
        && ln -s /opt/local/odoo/odoo/odoo-bin /usr/bin/odoo \
        && useradd odoo -d /opt/local/odoo -p odoo \
        && chown -R odoo /opt/local/odoo

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]

