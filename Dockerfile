FROM quay.io/keycloak/keycloak:latest as builder

# Enable health checks and metrics
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_DB=postgres

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Back4app uses a proxy; we must inform Keycloak to trust it
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized", "--proxy=edge", "--hostname-strict=false", "--http-enabled=true"]
