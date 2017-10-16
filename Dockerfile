FROM debian:stretch
MAINTAINER Niboo SPRL <info@niboo.be>

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            node-less \
            python-gevent \
            python-pip \
            python-pyinotify \
            python-renderpm \
            python-support \
            git \
            ssh-client \
            postgresql-client \
            python-babel \
            python-greenlet \
            python-markupsafe \
            python-dateutil \
            python-decorator \
            python-docutils \
            python-feedparser \
            python-imaging \
            python-jinja2 \
            python-ldap \
            python-libxslt1 \
            python-lxml \
            python-mako \
            python-mock \
            python-openid \
            python-passlib \
            python-ofxparse \
            python-psutil \
            python-psycopg2 \
            python-pychart \
            python-pydot \
            python-pyparsing \
            python-pypdf \
            python-qrcode \
            python-usb \
            python-serial \
            python-reportlab \
            python-requests \
            python-tz \
            python-vatnumber \
            python-vobject \
            python-werkzeug \
            python-xlwt \
            python-yaml \
            python-six \
            python-xlsxwriter \
            python-wsgiref \
            python-unicodecsv \
            python-pypdf2 \
            python-html2text \
        && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb \
        && echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb \
        && pip install psycogreen==1.0 \
        && pip install suds-jurko \
        && pip install jcconv \
        && pip install num2words

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
CMD ["/usr/bin/python /opt/local/odoo/odoo/odoo-bin"]
