FROM golang:alpine as builder

# change platfrom to yours , ref https://github.com/Dreamacro/clash/blob/master/Makefile
ENV PLATFORM linux-armv8
ENV COUNTRY_DB_URL https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb
RUN apk add --no-cache make git && \
    wget -O /Country.mmdb ${COUNTRY_DB_URL} && \
    git clone https://github.com/Dreamacro/clash.git /clash-src

RUN cd /clash-src && \
    go mod download && \
    make ${PLATFORM} && \
    mv ./bin/clash-${PLATFORM} /clash


FROM alpine:3.11.2

# RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.11/main/" > /etc/apk/repositories
COPY --from=builder /Country.mmdb /root/.config/clash/
COPY --from=builder /clash /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/
COPY config.yaml /root/.config/clash/

RUN apk add --no-cache \
 ca-certificates  \
 bash  \
 iptables  \
 bash-doc  \
 bash-completion  \
 rm -rf /var/cache/apk/* && \
 chmod a+x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["/usr/local/bin/clash","-d","/clash_config"]

