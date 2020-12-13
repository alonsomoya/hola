FROM bitnami/minideb AS zola-base
ENV ZOLA_VERSION v0.7.0
RUN install_packages python-pip curl tar python-setuptools rsync binutils
RUN pip install dockerize
RUN mkdir -p /workdir
WORKDIR /workdir
RUN curl -L https://github.com/getzola/zola/releases/download/$ZOLA_VERSION/zola-$ZOLA_VERSION-x86_64-unknown-linux-gnu.tar.gz | tar xz
RUN mv zola /usr/bin
RUN dockerize -n --verbose -o /workdir  /usr/bin/zola

FROM zola-base as builder
COPY . /workdir
RUN /usr/bin/zola build

FROM nginx:stable-alpine
RUN mv /usr/share/nginx/html/index.html /usr/share/nginx/html/old-index.html
COPY --from=builder /workdir/public/ /usr/share/nginx/html/
RUN chmod 755 /usr/share/nginx/html/**/*
EXPOSE 80

