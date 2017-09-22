#!/bin/bash

set -e

# set the postgres database host, port, user and password according to the environment
# and pass them as arguments to the odoo process if not present in the config file
: ${HOST:=${DB_PORT_5432_TCP_ADDR:='db'}}
: ${PORT:=${DB_PORT_5432_TCP_PORT:=5432}}
: ${USER:=${DB_ENV_POSTGRES_USER:=${POSTGRES_USER:='odoo'}}}
: ${PASSWORD:=${DB_ENV_POSTGRES_PASSWORD:=${POSTGRES_PASSWORD:='odoo'}}}
: ${DB_FILTER:=${DB_FILTER:='.*'}}
: ${WORKERS:=${ODOO_WORKERS:='2'}}
: ${LIMIT_MEMORY_HARD:=${ODOO_LIMIT_MEMORY_HARD:='2684354560'}}
: ${LIMIT_MEMORY_SOFT:=${ODOO_LIMIT_MEMORY_SOFT:='2147483648'}}
: ${LIMIT_REQUEST:=${ODOO_LIMIT_REQUEST:='8192'}}
: ${LIMIT_TIME_CPU:=${ODOO_LIMIT_TIME_CPU:='180'}}
: ${LIMIT_TIME_REAL:=${ODOO_LIMIT_TIME_CPU:='300'}}

ODOO_ARGS=()
function check_param() {
    param="$1"
    value="$2"
    # Check that there is a value for the parameter before passing it to launch odoo
    if ! [[ -z "$value" ]]; then
        ODOO_ARGS+=("--${param}")
        ODOO_ARGS+=("${value}")
    fi;
}

check_param "db_host" "$HOST"
check_param "db_port" "$PORT"
check_param "db_user" "$USER"
check_param "db_password" "$PASSWORD"
check_param "dbfilter" "$DB_FILTER"
check_param "workers" "$DB_FILTER"
check_param "limit_memory_hard" "$LIMIT_MEMORY_HARD"
check_param "limit_memory_soft" "$LIMIT_MEMORY_SOFT"
check_param "limit_request" "$LIMIT_REQUEST"
check_param "limit_time_cpu" "$LIMIT_TIME_CPU"
check_param "limit_time_real" "$LIMIT_TIME_REAL"

case "$1" in
    -- | odoo)
        shift
        if [[ "$1" == "scaffold" ]] ; then
            exec odoo "$@"
        else
            exec odoo "$@" "${ODOO_ARGS[@]}"
        fi
        ;;
    -*)
        exec odoo "$@" "${ODOO_ARGS[@]}"
        ;;
    *)
        exec "$@"
esac

exit 1
