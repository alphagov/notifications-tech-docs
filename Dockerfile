FROM ruby:2.7-slim

RUN \
	echo "Install Debian packages" \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
    build-essential

WORKDIR /var/project

COPY . .
RUN make bootstrap
