FROM debian:buster-slim

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    BEAST_PORT=30005

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY rootfs/ /

# hadolint ignore=SC1091
RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
  ntp git wget curl build-essential python3-dev python3-venv \
  socat netcat uuid-runtime zlib1g-dev zlib1g \
  libncurses6 libncurses-dev && \
  # S6 OVERLAY
  chmod +x /scripts/s6-overlay.sh && \
  /scripts/s6-overlay.sh && \
  # Healthcheck
  chmod +x /healthcheck.sh && \
  # ADSBExchange
  mkdir -p /usr/local/share/adsbexchange && \
  git clone --depth 2 -b master https://github.com/adsbxchange/adsb-exchange.git /srv/adsbexchange && \
  pushd /srv/adsbexchange && \
  cp scripts/*.sh /usr/local/share/adsbexchange && \
  git rev-parse HEAD > /usr/local/share/adsbexchange/feeder_version && \
  popd && \
  # MLAT
  git clone --depth 2 -b master https://github.com/adsbxchange/mlat-client.git /srv/mlat-client && \
  pushd /srv/mlat-client && \
  /usr/bin/python3 -m venv /usr/local/share/adsbexchange/venv && \
  source /usr/local/share/adsbexchange/venv/bin/activate && \
  python3 setup.py build && \
  python3 setup.py install && \
  git rev-parse HEAD > /usr/local/share/adsbexchange/venv/mlat_version && \
  popd && \
  # feed-ADSBx
  git clone --depth 2 -b master https://github.com/adsbxchange/readsb.git /src/readsb && \
  pushd /src/readsb && \
  make -j2 AIRCRAFT_HASH_BITS=12 RTLSDR=no BLADERF=no PLUTOSDR=no HAVE_BIASTEE=no && \
  cp -v /src/readsb/readsb /usr/local/share/adsbexchange/feed-adsbx && \
  git rev-parse HEAD > /usr/local/share/adsbexchange/readsb_version && \
  popd && \
  apt-get remove -y build-essential python3-dev libncurses-dev zlib1g-dev && \
  apt-get autoremove -y && \
  rm -rf  /src /scripts /var/lib/apt/lists/*

ENTRYPOINT [ "/init" ]
EXPOSE 30105
HEALTHCHECK --start-period=120s --interval=300s CMD /healthcheck.sh
LABEL maintainer="Jeremie-C <Jeremie-C@users.noreply.github.com>"
