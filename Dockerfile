FROM golang:alpine as builder


RUN apk add --no-cache make git && \
    git clone https://github.com/Dreamacro/clash.git /clash-src

WORKDIR /clash-src

RUN go mod download

COPY Makefile /clash-src/Makefile
RUN make current


FROM alpine:3.18.3

# RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.11/main/" > /etc/apk/repositories

COPY --from=builder /clash-src/bin/clash /usr/local/bin/
COPY Country.mmdb /root/.config/clash/
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

