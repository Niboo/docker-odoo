FROM debian:stretch
MAINTAINER Niboo SPRL <info@niboo.be>

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf

RUN set -x; \
        apt-get update \
        && apt-get update --fix-missing \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            node-less \
            python3-pip \
            python3-setuptools \
            python3-renderpm \
            libssl1.0-dev \
            xz-utils \
            python3-watchdog \
            python3-dateutil \
            python3-psutil \
            git \
        && pip3 install openpyxl  \
        && pip3 install --upgrade six \
        && pip3 install PyPDF2 \
        && pip3 install passlib \
        && pip3 install babel \
        && pip3 install werkzeug \
        && pip3 install lxml \
        && pip3 install decorator \
        && pip3 install psycopg2 \
        && pip3 install Pillow \
        && pip3 install wheel \
        && pip3 install requests \
        && pip3 install jinja2 \
        && pip3 install gevent \
        && pip3 install reportlab \
        && pip3 install html2text \
        && pip3 install docutils \
        && pip3 install libsass \
        && pip3 install num2words \
        && pip3 install xlwt \
        && curl -o wkhtmltox.deb -SL https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb \
        && apt install -y ./wkhtmltox.deb \
        && rm wkhtmltox.deb

# Install Odoo
ENV ODOO_ORIGINAL_TAG "v12.0.2.0"

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /

RUN set -x; \
        mkdir -p /opt/local/odoo \
        && mkdir -p /opt/local/odoo/.local/share \
        && useradd odoo -d /opt/local/odoo -p odoo \
        && chown -R odoo:odoo /opt/local/odoo

# Set default user when running the container
USER odoo

RUN set -x; \
        cd /opt/local/odoo \
        && git clone -b ${ODOO_ORIGINAL_TAG} --single-branch --depth 1 https://github.com/Niboo/odoo.git odoo

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/opt/local/odoo/odoo/odoo-bin"]
