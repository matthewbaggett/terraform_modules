FROM alpine:3.18 AS headscale-alpine
RUN apk add --no-cache \
      ca-certificates \
      bash
ENTRYPOINT ["/usr/bin/headscale"]
CMD ["/usr/bin/headscale", "serve"]
COPY --from=headscale/headscale:stable /ko-app/headscale /usr/bin/headscale
RUN chmod +x /usr/bin/headscale && \
    headscale version
