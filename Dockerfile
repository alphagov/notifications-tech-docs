FROM ruby:2.4.4-slim

ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY

RUN \
	echo "Install Debian packages" \
	&& ([ -z "$HTTP_PROXY" ] || echo "Acquire::http::Proxy \"${HTTP_PROXY}\";" > /etc/apt/apt.conf.d/99HttpProxy) \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		build-essential \
		curl \
		g++ \
		gcc \
		git \
		make \
	&& echo "Clean up" \
	&& rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /var/project
COPY Gemfile* /var/project/
RUN bundle install
