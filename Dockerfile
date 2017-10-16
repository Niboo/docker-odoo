FROM debian:stretch
MAINTAINER Niboo SPRL <info@niboo.be>

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            node-less \
            ssh-client \
            postgresql-client \
            python3-pip \
            python3-setuptools \
            python3-renderpm \
            python3-babel \
            python3-bs4 \
            python3-chardet \
            python3-dateutil \
            python3-decorator \
            python3-docutils \
            python3-feedparser \
            python3-gevent \
            python3-greenlet \
            python3-html2text \
            python3-jinja2 \
            python3-lxml \
            python3-mako \
            python3-markupsafe \
            python3-mock \
            python3-ofxparse \
            python3-passlib \
            python3-pbr \
            python3-pil \
            python3-psutil \
            python3-psycopg2 \
            python3-pydot \
            python3-pyparsing \
            python3-pypdf2 \
            python3-reportlab \
            python3-reportlab-accel \
            python3-requests \
            python3-roman \
            python3-serial \
            python3-six \
            python3-stdnum \
            python3-suds \
            python3-tz \
            python3-urllib3 \
            python3-usb \
            python3-vatnumber \
            python3-werkzeug \
            python3-xlsxwriter \
            python3-yaml \
            libssl1.0-dev \
            xz-utils \
            git \
        && curl -o wkhtmltox.tar.xz -SL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
        && echo '3f923f425d345940089e44c1466f6408b9619562 wkhtmltox.tar.xz' | sha1sum -c - \
        && tar xvf wkhtmltox.tar.xz \
        && cp wkhtmltox/lib/* /usr/local/lib/ \
        && cp wkhtmltox/bin/* /usr/local/bin/ \
        && cp -r wkhtmltox/share/man/man1 /usr/local/share/man/ \
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
CMD ["odoo"]
