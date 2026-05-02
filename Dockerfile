FROM quay.io/keycloak/keycloak:latest as builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_DB=postgres

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Updated for Keycloak 24/25+ 
# Replaced --proxy=edge with --proxy-headers=xforwarded
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized", "--proxy-headers=xforwarded", "--hostname-strict=false", "--http-enabled=true"]
