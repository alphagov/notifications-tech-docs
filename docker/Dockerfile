##### Ruby Build Image ########################################################
FROM ruby:3.2-slim-bookworm as ruby_build

RUN \
	echo "Install Debian packages" \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		build-essential ruby-dev \
	&& gem install bundler:2.3.22

WORKDIR /var/project

COPY . .
RUN make bootstrap

RUN mkdir production

# Generate production static files
RUN make production generate-tech-docs-yml
RUN bundle exec middleman build
RUN mv build/ production/build/

##### Production Build Image ##################################################
FROM nginx:1.25-bookworm as production

RUN mkdir -p /etc/nginx/production_static_files

# copy the static build files from the previous stage
COPY --from=ruby_build /var/project/production/build /etc/nginx/production_static_files

# overwrite the default nginx.conf file with our own custom one
COPY nginx.conf /etc/nginx/nginx.conf
