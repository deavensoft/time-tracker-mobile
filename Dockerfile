FROM ubuntu:18.04

ARG PROJECT_DIR=/workspaces/time_tracker_mobile
ENV PATH=/opt/flutter/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update && \
    apt-get install -y \
        xz-utils \
        git \
        openssh-client \
        curl && \
    rm -rf /var/cache/apt

RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_2.2.1-stable.tar.xz | tar -C /opt -xJ

WORKDIR ${PROJECT_DIR}
COPY ./ ./

ARG HOST
ARG PORT
RUN echo $HOST
RUN echo $PORT

RUN flutter doctor
RUN flutter upgrade
RUN flutter clean
RUN flutter pub get
RUN flutter build web --dart-define=IP="${HOST}" --dart-define=PORT="${PORT}"
RUN flutter pub global activate dhttpd