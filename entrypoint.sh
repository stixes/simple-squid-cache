#!/bin/ash
set -e

SQUID_LOG_DIR=/var/log/squid
SQUID_USER=squid

build_config() {
  if [ ! -f "/etc/squid/squid.conf" ]; then
    envsubst < /squid.conf.tmpl > /etc/squid/squid.conf
  fi
}

create_log_dir() {
  mkdir -p ${SQUID_LOG_DIR}
  chmod -R 755 ${SQUID_LOG_DIR}
  chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR}
}

create_cache_dir() {
  mkdir -p ${SQUID_CACHE_DIR}
  chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR}
}

build_config
create_log_dir
create_cache_dir

# default behaviour is to launch squid
if [[ -z ${1} ]]; then
  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initializing cache..."
    $(which squid) -N -f /etc/squid/squid.conf -z
  fi
  echo "Starting squid..."
  exec $(which squid) -f /etc/squid/squid.conf -NYCd 1
else
  exec "$@"
fi
