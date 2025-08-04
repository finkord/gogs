# Stage 1: Build Gogs and OpenTelemetry
FROM golang:alpine3.21 AS binarybuilder

# Install build dependencies
RUN apk --no-cache --no-progress add --virtual \
  build-deps \
  build-base \
  linux-pam-dev \
  clang \
  llvm \
  curl\
  git \
  gcc \
  tar 

# Set workdir
WORKDIR /gogs.io/gogs

COPY . .

# Install Task
RUN ./docker/build/install-task.sh

# Build Gogs
RUN TAGS="cert pam" task build

# Stage 2: Final runtime image
FROM alpine:3.21

# Install runtime dependencies only
RUN apk --no-cache --no-progress add \
  bash \
  ca-certificates \
  curl \
  git \
  linux-pam \
  openssh \
  s6 \
  shadow \
  socat \
  tzdata \
  rsync \
  gettext

# Set environment
ENV GOGS_CUSTOM=/data/gogs
# ENV PATH="/app/otelcol:${PATH}"

# Configure LibC Name Service
COPY docker/nsswitch.conf /etc/nsswitch.conf

# Create app dir
WORKDIR /app/gogs

# Copy runtime files
COPY docker ./docker
COPY --from=binarybuilder /gogs.io/gogs/gogs .

RUN ./docker/build/finalize.sh

# Volumes and ports
VOLUME ["/data", "/backup"]
EXPOSE 22 3000

# Healthcheck and entrypoint
HEALTHCHECK CMD (curl -o /dev/null -sS http://localhost:3000/healthcheck) || exit 1
ENTRYPOINT ["/app/gogs/docker/start.sh"]
CMD ["/usr/bin/s6-svscan", "/app/gogs/docker/s6/"]
