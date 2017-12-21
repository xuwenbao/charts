FROM alpine:3.7
MAINTAINER Wenbao Xu<xuwenbao@chinacloud.com.cn>

RUN apk update && apk --no-cache add bash curl openssl
RUN /usr/bin/curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | /bin/bash
COPY stable-archives /srv/charts

ENV SERVER_URL charts
EXPOSE 80
CMD /usr/local/bin/helm serve --address 0.0.0.0:80 --repo-path /srv/charts --url $SERVER_URL
