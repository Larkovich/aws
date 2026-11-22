# syntax=docker/dockerfile:1

# Build stage: runs natively on the build host and cross-compiles for the target arch (no QEMU)
FROM --platform=$BUILDPLATFORM golang:1.27-alpine@sha256:70bd7ddea8b6cbe5d6943cde279d6b67feb10cc924fb9100d1d8757c1575b280 AS build
ARG TARGETOS
ARG TARGETARCH
WORKDIR /src

# Copy go.mod first so dependancies are cached between builds
COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -trimpath -ldflags="-s -w" -o /out/status-api .

# Runtime stage: distroless has no shell and no package manager
FROM gcr.io/distroless/static-debian13:nonroot@sha256:aafe993665bf6200db38a02c11a9351e782a84b6a45e7f33b6695638c88e3931

COPY --from=build /out/status-api /status-api

# Run as non-root user (uid 65532) provided by the distroless image
USER 65532:65532
EXPOSE 8080

ENTRYPOINT ["/status-api"]
