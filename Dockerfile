FROM scratch
ENV LANG=C.UTF-8
#built using mmdebstrap --varian=essential
ADD variant-essential+apt/debian-rootfs-essential-apt-trixie-aarch64.tar.gz /
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/.deb /var/tmp/ /tmp/*
EXPOSE 22 53 80 443
CMD ["sh"]
#after container built, edit entrypoint as neccesary
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
