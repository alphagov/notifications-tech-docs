FROM ghcr.io/alphagov/notify/ruby:2.7.6-bullseye

RUN \
	echo "Install Debian packages" \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		build-essential ruby-dev \
	&& gem install bundler:2.3.22

WORKDIR /var/project

COPY . .
RUN make bootstrap
