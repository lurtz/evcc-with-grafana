FROM docker.io/evcc/evcc:nightly.20250927-4a4027c
COPY evcc-bin /usr/local/bin/evcc

# mDNS
EXPOSE 5353/udp
# EEBus
EXPOSE 4712/tcp
# UI and /api
EXPOSE 7070/tcp
# KEBA charger
EXPOSE 7090/udp
# OCPP charger
EXPOSE 8887/tcp
# Modbus UDP
EXPOSE 8899/udp
# SMA Energy Manager
EXPOSE 9522/udp

HEALTHCHECK --interval=60s --start-period=60s --timeout=30s --retries=3 CMD [ "evcc", "health" ]

ENTRYPOINT [ "/app/entrypoint.sh" ]
CMD [ "evcc" ]
