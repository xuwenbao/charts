ARG SOURCE_DIR=/srv/charts
ARG ARCHIVES_DIR=/srv/chart-archives


FROM alpine:3.7 as builder

ARG SOURCE_DIR
ARG ARCHIVES_DIR

RUN apk update && apk --no-cache add bash curl openssl
RUN /usr/bin/curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | /bin/bash

COPY . $SOURCE_DIR
RUN mkdir -p $ARCHIVES_DIR
RUN for d in $(ls $SOURCE_DIR); \
    do \
        if test -d $SOURCE_DIR/$d;then \
            echo $SOURCE_DIR/$d &&  \
            /usr/local/bin/helm package -u -d $ARCHIVES_DIR --save=false $SOURCE_DIR/$d; \
        fi \
    done


FROM alpine:3.7 as prod
MAINTAINER Wenbao Xu<xu-wenbao@foxmail.com>

ARG ARCHIVES_DIR
ENV SERVER_URL charts

COPY --from=builder $ARCHIVES_DIR $ARCHIVES_DIR
COPY --from=builder /usr/local/bin/helm /usr/local/bin/

EXPOSE 80
CMD /usr/local/bin/helm serve --address 0.0.0.0:80 --repo-path $ARCHIVES_DIR --url $SERVER_URL
