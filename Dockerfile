FROM registry.fedoraproject.org/fedora:35 AS builder
RUN dnf install -y cargo openssl-devel xz-devel
WORKDIR /build
COPY Cargo.* ./
COPY src src/
RUN cargo build --release

FROM registry.fedoraproject.org/fedora:35
RUN dnf install -y /usr/bin/gpg /usr/sbin/kpartx /usr/bin/lsblk \
    /usr/sbin/udevadm && \
    dnf clean all
COPY --from=builder /build/target/release/coreos-installer /usr/sbin
ENTRYPOINT ["/usr/sbin/coreos-installer"]
