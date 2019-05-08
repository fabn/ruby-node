FROM ruby:2.3.1
MAINTAINER Fabio Napoleoni <f.napoleoni@gmail.com>
# Bundler updated version
ENV BUNDLER_VERSION 1.17.3
# Debian repository versions
ENV YARN_VERSION=1.15.2-1
# Fix debian Jessie Archives
COPY sources.list /etc/apt
# Update package cache and install https transport
RUN apt-get update -qq && apt-get -y install apt-transport-https curl
# Packages repositories for yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
# Setup node
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
# Update package cache
RUN apt-get update -qq
# Install apt dependencies
RUN apt-get install -y --no-install-recommends \
  build-essential \
  nodejs yarn=${YARN_VERSION} \
  curl libssl-dev \
  git \
  unzip \
  zlib1g-dev \
  libxslt-dev \
  mysql-client
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Update bundler
RUN gem install bundler -v=${BUNDLER_VERSION}
