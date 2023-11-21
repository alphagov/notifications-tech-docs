FROM ruby:3.2-bookworm

RUN \
	echo "Install Debian packages" \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		build-essential ruby-dev \
	&& gem install bundler:2.3.22

WORKDIR /var/project

COPY . .
RUN make bootstrap
